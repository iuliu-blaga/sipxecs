import 'dart:html';
import 'dart:convert';
import 'package:sipxconfig/sipxconfig.dart';

var api = new Api(test : false);

main() {
  new DnsViewEditor();
}

class DnsViewEditor {
  var msg = new UserMessage(querySelector("#message"));
  DataLoader loader;
  int dnsViewId;
  
  DnsViewEditor() {
    querySelector("#ok").onClick.listen(ok);
    querySelector("#apply").onClick.listen(apply);
    querySelector("#cancel").onClick.listen(cancel);    
    Location l = document.window.location;
    var params = Uri.parse(l.href).queryParameters;
    if (params['dnsViewId'] != null) {
      dnsViewId = int.parse(params['dnsViewId']);
    }
    loader = new DataLoader(this.msg, loadForm);    
    load();
  }
      
  ok(e) {
    save(close);
  }

  apply(e) {
    save();
  }
  
  cancel(e) {
    close();
  }
  
  close() {
    window.location.href = 'EditDns.html';      
  }

  save([onOk]) {
    var meta = new Map<String,Object>();
    meta['planId'] = int.parse((querySelector("#planId") as SelectElement).value);
    meta['name'] = (querySelector("#name") as InputElement).value;
    meta['regionId'] = int.parse((querySelector("#regionId") as SelectElement).value);
    HttpRequest req = new HttpRequest();
    var method;
    var id = '';        
    if (dnsViewId == null) {
      method = 'POST';            
    } else {
      id = "${dnsViewId}/";
      meta['id'] = dnsViewId;
      method = 'PUT';            
    }
    req.open(method, api.url("rest/dnsView/${id}"));
    req.setRequestHeader("Content-Type", "application/json"); 
    req.send(JSON.encode(meta));
    req.onLoad.listen((e) {
      if (DataLoader.checkResponse(msg, req)) {
        if (dnsViewId == null) {
          dnsViewId = int.parse(req.responseText);
        }
        if (onOk != null) {
          msg.success("Save successful");
          onOk();
        }
      }
    });      
  }  
  
  load() {
    var id = (dnsViewId != null ? '${dnsViewId}' : 'blank');
    var url = api.url("rest/dnsView/${id}", "edit-view-test.json");
    loader.load(url);
  }
  
  loadRegionCandidates(Map<String, String> regionOptions, int regionId) {
    String regionIdStr = (regionId == null ? null : regionId.toString());
    SelectElement select = querySelector("#regionId");
    regionOptions.forEach((id, value) {
      bool selected = (int.parse(id) == regionId);
      select.append(new OptionElement(data: value, value: id, selected : selected));        
    });
  }
  
  loadPlanOptions(Map<String, String> planOptions, int planId) {
    String planIdStr = (planId == null ? null : planId.toString());
    SelectElement select = querySelector("#planId");
    planOptions.forEach((id, value) {
      bool selected = (int.parse(id) == planId);
      select.append(new OptionElement(data: value, value: id, selected : selected));
    });
  }
  
  loadForm(json) {
    var data = JSON.decode(json);
    Map<String, Object> view = data['view'];
    int regionId;
    int planId;
    if (view != null) {
      (querySelector("#name") as InputElement).value = view['name'];
      regionId = view['regionId'];
      planId = view['planId'];
    }
    loadRegionCandidates(data['regionCandidates'], regionId);
    loadPlanOptions(data['planCandidates'], planId);
  }  
}

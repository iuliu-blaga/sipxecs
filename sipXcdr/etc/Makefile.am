include $(top_srcdir)/config/utility.am

EXTRA_DIST = \
	$(tmpfilesd_SCRIPTS:=.in)

sqldir = @SIPX_CONFDIR@/cdr
dist_sql_DATA = \
	database/schema.sql \
	database/refer_uri.sql \
	database/view_cdrs.sql \
	database/index_on_time.sql \
	database/reference.sql \
	database/contact.sql \
	database/calldirection.sql \
	database/cdrremote.sql \
	database/transaction.sql \
	database/gateway.sql

cfinputsdir = @SIPX_CFINPUTS@/plugin.d
dist_cfinputs_DATA = \
	sipxcdr.cf

tmpfilesddir = /etc/tmpfiles.d
tmpfilesd_SCRIPTS = \
	sipxcdr.conf

$(tmpfilesd_SCRIPTS) : % : %.in Makefile
	@$(call SearchAndReplace,$<,$@)

CLEANFILES = $(tmpfilesd_SCRIPTS)

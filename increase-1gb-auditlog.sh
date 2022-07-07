#!/bin/sh

## Log Function
readonly LOGFILE="/Library/Logs/TechSupport/jamf-auditlog-increase.log"
readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  /bin/echo "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" | tee -a ${LOGFILE}
}
  mkdir -p /Library/Logs/TechSupport/
  touch ${LOGFILE}

## Main
Check_Flag=`cat /etc/security/audit_control | egrep expire-after`
CMD=`sed -i '' -e "s/expire-after:10M/expire-after:60D OR 1G/g" /etc/security/audit_control`

if [ ${Check_Flag} = 'expire-after:60D OR 1G' ]
then
	log "audit_control acl check"
	log "/etc/security/audit_control is OK"
else
	log "audit_control acl check"
	log "/etc/security/audit_control is NG"
	log "Audit Log increase 60D OR 1G"
	${CMD}
fi

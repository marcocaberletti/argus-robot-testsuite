*** Settings ***
Resource   lib/utils.robot

Suite Setup     Make backup of the configuration
Suite Teardown  Restore configurations


*** Test Cases ***
PEP status
  Ensure PEP running
  ${cmd}=  Set Variable  ${T_PEP_CTRL} status | grep -q "Status: OK"
  Execute and Check Success  ${cmd}

PEP with SSL
  Ensure PEP stopped
  ${file}=  Join Path  ${T_PEP_CONF}  ${T_PEP_INI}
  Change parameter value  ${file}  enableSSL  true
  Start PEP service
  ${cmd}=  Set Variable  ${T_PEP_CTRL} status | grep -q "Status: OK"
  Execute and Check Success  ${cmd}
  [Teardown]  Restore PEP configuration

PEP with no config file
  Ensure PEP stopped
  ${file}=  Join Path  ${T_PEP_CONF}  ${T_PEP_INI}
  Remove File  ${file}
  Execute and Check Failure  ${T_PEP_CONF} start
  ${cmd}=  Set Variable  ${T_PEP_CTRL} status | grep -q "Status: OK"
  Execute and Check Failure  ${cmd}
  [Teardown]  Restore PEP configuration

Error exit codes (bug 65542)
  Ensure PEP stopped
  Execute and Check Failure  ${T_PEP_CTRL} status

Works with non PIPs defined (bug 69263)
  Ensure PEP stopped
  ${file}=  Join Path  ${T_PEP_CONF}  ${T_PEP_INI}
  Comment parameter  ${file}  pips
  Ensure PEP running
  [Teardown]  Restore PEP configuration

The proposed file-structure for is given (bug 77532)
  ${file}=  Set Variable  /usr/sbin/pepdctl
  Check file  ${file}
  ${dir}=  Set Variable  /etc/argus/pepd
  Check directory  ${dir}

Check PID file (bug 80510)
  ${file}=  Set Variable  /var/run/argus-pepd.pid
  Ensure PEP running
  Check File  ${file}

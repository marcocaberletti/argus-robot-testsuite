** Settings ***

Library    OperatingSystem
Library    Process
Resource   variables.robot

Resource   common_utils.robot

Variables  ${ENV_FILE}

*** Keywords ***

Check port  [Arguments]  ${hostname}  ${port}
  ${cmd}=  Set Variable  (echo > /dev/tcp/${hostname}/${port}) &>/dev/null
  ${rc}  ${output}=  Run And Return Rc And Output  ${cmd}
  Should Be Equal As Integers  ${rc}  0

Port not reachable  [Arguments]  ${hostname}  ${port}
  ${cmd}=  Set Variable  (echo > /dev/tcp/${hostname}/${port}) &>/dev/null
  ${rc}  ${output}=  Run And Return Rc And Output  ${cmd}
  Should Be Equal As Integers  ${rc}  1

Ensure PAP running
  ${status}=  Get PAP status
  Run Keyword If  ${status}!=0  Start PAP service

Ensure PDP running
  ${status}=  Get PDP status
  Run Keyword If  ${status}!=0  Start PDP service

Ensure PEP running
  ${status}=  Get PEP status
  Run Keyword If  ${status}!=0  Start PEP service

Ensure PAP stopped
  ${status}=  Get PAP status
  Run Keyword If  ${status}==0  Stop PAP service

Ensure PDP stopped
  ${status}=  Get PDP status
  Run Keyword If  ${status}==0  Stop PDP service

Ensure PEP stopped
  ${status}=  Get PEP status
  Run Keyword If  ${status}==0  Stop PEP service

Get PAP status
  ${rc}  ${output}=  Run And Return Rc And Output  papctl status
  [Return]  ${rc}

Get PDP status
  ${rc}  ${output}=  Run And Return Rc And Output  pdpctl status
  [Return]  ${rc}

Get PEP status
  ${rc}  ${output}=  Run And Return Rc And Output  pepdctl status
  [Return]  ${rc}

Restore services
  Stop PAP service
  Stop PDP service
  Stop PEP service
  Sleep  5
  Start PAP service
  Start PDP service
  Start PEP service

Restart PAP service
  Ensure PAP stopped
  Ensure PAP running

Restart PDP service
  Ensure PDP stopped
  Ensure PDP running

Restart PEP service
  Ensure PEP stopped
  Ensure PEP running

Start PAP service
  Start process  papctl  start
  ${hostname}=  Get hostname
  Wait Until Keyword Succeeds  2 min  5 sec  Check port  ${hostname}  ${T_PAP_PORT}
  Log  PAP started

Start PDP service
  Start process  pdpctl  start
  ${hostname}=  Get hostname
  Wait Until Keyword Succeeds  2 min  5 sec  Check port  ${hostname}  ${T_PDP_PORT}
  Log  PDP started

Start PEP service
  Start process  pepdctl  start
  ${hostname}=  Get hostname
  Wait Until Keyword Succeeds  2 min  5 sec  Check port  ${hostname}  ${T_PEP_PORT}
  Log  PEP started

Stop PAP service
  Start process  papctl  stop
  ${hostname}=  Get hostname
  Wait Until Keyword Succeeds  2 min  5 sec  Port not reachable  ${hostname}  ${T_PAP_PORT}
  Log  PAP stopped

Stop PDP service
  Start process  pdpctl  stop
  ${hostname}=  Get hostname
  Wait Until Keyword Succeeds  2 min  5 sec  Port not reachable  ${hostname}  ${T_PDP_PORT}
  Log  PDP stopped

Stop PEP service
  Start process  pepdctl  stop
  ${hostname}=  Get hostname
  Wait Until Keyword Succeeds  2 min  5 sec  Port not reachable  ${hostname}  ${T_PEP_PORT}
  Log  PEP stopped

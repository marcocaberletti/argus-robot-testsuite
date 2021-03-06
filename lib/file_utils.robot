** Settings ***

Library    OperatingSystem
Library    String
Resource   variables.robot

Resource   common_utils.robot

Variables  ${ENV_FILE}


*** Keywords ***

Check directory  [Arguments]  ${directory}
  Directory Should Exist  ${directory}
  Directory Should Not Be Empty  ${directory}

Check file  [Arguments]  ${file}
  File Should Exist  ${file}
  File Should Not Be Empty  ${file}

Create working directory
  ${time}=  Get Time
  ${time}=  Replace String Using Regexp  ${time}  ${SPACE}  _
  ${time}=  Replace String Using Regexp  ${time}  :|-  ${EMPTY}
  ${workdir}=  Join Path  ${TMP_DIR}  argus-testsuite_${time}
  Create Directory  ${workdir}
  [Return]  ${workdir}
  
Empty file  [Arguments]  ${file}
  Create File  ${file}

Make backup of the configuration
  ${workdir}=  Create working directory
  Set Environment Variable  WORKDIR  ${workdir}
  ${bck_conf_dir}=  Join Path  ${workdir}  conf_backup
  Create Directory  ${bck_conf_dir}
  Copy File  ${T_PDP_CONF}/${T_PDP_INI}  ${bck_conf_dir}
  Copy File  ${T_PEP_CONF}/${T_PEP_INI}  ${bck_conf_dir}
  Copy File  ${T_PEP_CONF}/vo-ca-ap-file  ${bck_conf_dir}
  Copy File  ${T_PAP_CONF}/${T_PAP_ADMIN_INI}  ${bck_conf_dir} 
  Copy File  ${T_PAP_CONF}/${T_PAP_AUTH_INI}  ${bck_conf_dir}
  Copy File  ${T_PAP_CONF}/${T_PAP_CONF_INI}  ${bck_conf_dir}
  Copy File  ${GRIDDIR}/${GRIDMAPFILE}  ${bck_conf_dir}
  Copy File  ${GRIDDIR}/${GROUPMAPFILE}  ${bck_conf_dir}
  Copy File  ${GRIDDIR}/${VOMSGRIDMAPFILE}  ${bck_conf_dir}
  Copy File  ${GRIDDIR}/${AUTHN_PROFILE_FILE}  ${bck_conf_dir}
  Copy Directory  ${GRIDDIR}/${GRIDMAPDIR}    ${bck_conf_dir}

Remove all leases in gridmapdir
  Remove File  ${GRIDDIR}/${GRIDMAPDIR}/%*

Restore grid files
  ${bck_conf_dir}=  Join Path  %{WORKDIR}  conf_backup
  Copy File  ${bck_conf_dir}/${GRIDMAPFILE}  ${GRIDDIR}/${GRIDMAPFILE}
  Copy File  ${bck_conf_dir}/${GROUPMAPFILE}  ${GRIDDIR}/${GROUPMAPFILE}
  Copy File  ${bck_conf_dir}/${VOMSGRIDMAPFILE}  ${GRIDDIR}/${VOMSGRIDMAPFILE}
  Copy File  ${bck_conf_dir}/${AUTHN_PROFILE_FILE}  ${GRIDDIR}/${AUTHN_PROFILE_FILE}

Restore PAP configuration
  ${bck_conf_dir}=  Join Path  %{WORKDIR}  conf_backup
  Copy File  ${bck_conf_dir}/${T_PAP_CONF_INI}  ${T_PAP_CONF}/${T_PAP_CONF_INI}
  Copy File  ${bck_conf_dir}/${T_PAP_AUTH_INI}  ${T_PAP_CONF}/${T_PAP_AUTH_INI}
  Copy File  ${bck_conf_dir}/${T_PAP_ADMIN_INI}  ${T_PAP_CONF}/${T_PAP_ADMIN_INI}

Restore PDP configuration
  ${bck_conf_dir}=  Join Path  %{WORKDIR}  conf_backup
  Copy File  ${bck_conf_dir}/${T_PDP_INI}  ${T_PDP_CONF}/${T_PDP_INI}

Restore PEP configuration
  ${bck_conf_dir}=  Join Path  %{WORKDIR}  conf_backup
  Copy File  ${bck_conf_dir}/${T_PEP_INI}  ${T_PEP_CONF}/${T_PEP_INI}
  Copy File  ${bck_conf_dir}/vo-ca-ap-file  ${T_PEP_CONF}/vo-ca-ap-file
  Restore grid files
  
Restore configurations
  Restore PAP configuration
  Restore PDP configuration
  Restore PEP configuration
  
Touch pool account  [Arguments]  ${account}
  ${file}=  Set Variable  ${GRIDDIR}/${GRIDMAPDIR}/${account}
  Touch  ${file}
  
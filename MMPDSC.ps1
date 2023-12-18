#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft Windows 10 Enterprise build 21H1 with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
    This will also install LAPS (Local Administrator Password Solution) from the internet via download.microsoft.com unless the URL is changed to a network accesible path for your envrionment.
#>

# Configuration Microsoft_Windows_10_Enterprise_21H1_CIS_L1_with_LAPS
# {
#     Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
#     Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_10_Enterprise_Release_21H1'

#     node 'localhost'
#     {
#         Package 'InstallLAPS'
#         {
#             Name  = 'Local Administrator Password Solution'
#             Path = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
#             ProductId = '97E2CA7B-B657-4FF7-A6DB-30ECC73E1E28'
#         }

#         CIS_Microsoft_Windows_10_Enterprise_Release_21H1 'CIS Benchmarks'
#         { 
# 			 ExcludeList = @(
# 				'2.3.7.2', # (L1) Ensure 'Interactive logon: Don't display last signed-in' is set to 'Enabled'
# 				'18.8.28.2', # (L1) Ensure 'Do not display network selection UI' is set to 'Enabled'
# 				'18.9.4.2', # (L1) Ensure 'Prevent non-admin users from installing packaged Windows apps' is set to 'Enabled'
# 				'18.9.56.1' # (L1) Ensure 'Prevent the usage of OneDrive for file storage' is set to 'Enabled'
#         )
#             cis2315AccountsRenameadministratoraccount = 'CISAdmin'
#             cis2316AccountsRenameguestaccount = 'CISGuest'
#             cis2376LegalNoticeCaption = '"I UNDERSTAND AND CONSENT TO THE FOLLOWING:"'
#             cis2375LegalNoticeText = @"
# I am accessing a secure system The Vascular Care Group (The Company) provides for authorized use only, except as policy allows. Unauthorized use of the information system is prohibited and subject to criminal, civil, security, or administrative proceedings and penalties., USE OF THIS INFORMATION SYSTEM INDICATES CONSENT TO MONITORING AND RECORDING, INCLUDING PORTABLE ELECTRONIC DEVICES. The Company routinely monitors communications occurring on this information system. I have no reasonable expectation of privacy regarding any communications or data transiting or stored on this information system. At any time, The Company may monitor, search, or seize any communication or data transiting or stored on this information system for any lawful purpose. Any communications or data transiting or stored on this information system may be disclosed or used in accordance with federal and state laws and regulations. PLEASE REPORT ANY UNAUTHORIZED USE TO THE HELPDESK (x555) AND TECHNOLOGY DEPARTMENT PERSONNEL.
# "@
#             DependsOn = '[Package]InstallLAPS'
#         }
#     }
# }

Configuration CompositeConfiguration
{
    # Importing the necessary DSC resources
    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_10_Enterprise_Release_21H1'

    # Node configuration
    Node localhost
    {
      # Install LAPS
      Package 'InstallLAPS' {
        Name = "Local Administrator Password Solution"
        Path = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
        ProductId = '97E2CA7B-B657-4FF7-A6DB-30ECC73E1E28'
      }

      CIS_Microsoft_Windows_10_Enterprise_Release_21H1 'CIS Benchmarks' {
        ExcludeList = @(
          '2.3.7.2', # (L1) Ensure 'Interactive logon: Don't display last signed-in' is set to 'Enabled'
          '18.8.28.2', # (L1) Ensure 'Do not display network selection UI' is set to 'Enabled'
          '18.9.4.2', # (L1) Ensure 'Prevent non-admin users from installing packaged Windows apps' is set to 'Enabled'
          '18.9.56.1' # (L1) Ensure 'Prevent the usage of OneDrive for file storage' is set to 'Enabled'  
        )
        cis2315AccountsRenameadministratoraccount = 'CISAdmin'
        cis2316AccountsRenameguestaccount = 'CISGuest'
        cis2376LegalNoticeCaption = '"I UNDERSTAND AND CONSENT TO THE FOLLOWING:"'
        cis2375LegalNoticeText = @"
I am accessing a secure system The Vascular Care Group (The Company) provides for authorized use only, except as policy allows. Unauthorized use of the information system is prohibited and subject to criminal, civil, security, or administrative proceedings and penalties., USE OF THIS INFORMATION SYSTEM INDICATES CONSENT TO MONITORING AND RECORDING, INCLUDING PORTABLE ELECTRONIC DEVICES. The Company routinely monitors communications occurring on this information system. I have no reasonable expectation of privacy regarding any communications or data transiting or stored on this information system. At any time, The Company may monitor, search, or seize any communication or data transiting or stored on this information system for any lawful purpose. Any communications or data transiting or stored on this information system may be disclosed or used in accordance with federal and state laws and regulations. PLEASE REPORT ANY UNAUTHORIZED USE TO THE HELPDESK (x555) AND TECHNOLOGY DEPARTMENT PERSONNEL.
"@
        DependsOn = '[Package]InstallLAPS'
  } 
        # Chrome Homepage Configuration
        Registry 'ChromeHomepageLocation'
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Google\Chrome'
            ValueName = 'HomepageLocation'
            ValueType = 'String'
            ValueData = 'https://mangrovemp.sharepoint.com/sites/TVCGTeamSite'
        }

        Registry 'UpdateDefault'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Google\Update'
          ValueName = 'UpdateDefault'
          ValueType = 'DWord'
          ValueData = '3'
        }
        Registry 'Update{8A69D345-D564-463C-AFF1-A69D9E530F96}'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Google\Update'
          ValueName = 'Update{8A69D345-D564-463C-AFF1-A69D9E530F96}'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'GpNetworkStartTimeoutPolicyValue'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System'
          ValueName = 'GpNetworkStartTimeoutPolicyValue'
          ValueType = 'DWord'
          ValueData = '180'
        }
        Registry 'SyncForegroundPolicy'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon'
          ValueName = 'SyncForegroundPolicy'
          ValueType = 'DWord'
          ValueData = '1'
        }

        # Edge Homepage Configuration
        Registry 'EdgeHomepageLocation'
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge'
            ValueName = 'HomepageLocation'
            ValueType = 'String'
            ValueData = 'https://mangrovemp.sharepoint.com/sites/TVCGTeamSite'
        }

        # Additional Edge settings...

        # Microsoft Teams Configuration
        Registry 'TeamsEnableAutomaticUpdates'
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\Software\Policies\microsoft\office\16.0\common\officeupdate'
            ValueName = 'enableautomaticupdates'
            ValueType = 'DWord'
            ValueData = '1'
        }

        # Additional Teams settings...

        # Network Discovery Configuration
        Registry 'NetworkDiscoveryEnableLLTDIO'
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
            ValueName = 'EnableLLTDIO'
            ValueType = 'DWord'
            ValueData = '1'
        }

        Registry 'AllowLLTDIOOnDomain'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
          ValueName = 'AllowLLTDIOOnDomain'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'AllowLLTDIOOnPublicNet'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
          ValueName = 'AllowLLTDIOOnPublicNet'
          ValueType = 'DWord'
          ValueData = '0'
        }
        Registry 'ProhibitLLTDIOOnPrivateNet'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
          ValueName = 'ProhibitLLTDIOOnPrivateNet'
          ValueType = 'DWord'
          ValueData = '0'
        }
        Registry 'EnableRspndr'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
          ValueName = 'EnableRspndr'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'AllowRspndrOnDomain'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
          ValueName = 'AllowRspndrOnDomain'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'AllowRspndrOnPublicNet'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
          ValueName = 'AllowRspndrOnPublicNet'
          ValueType = 'DWord'
          ValueData = '0'
        }
        Registry 'ProhibitRspndrOnPrivateNet'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\LLTD'
          ValueName = 'ProhibitRspndrOnPrivateNet'
          ValueType = 'DWord'
          ValueData = '0'
        }

        # OneDrive Folder Redirection Configuration
        Registry 'OneDriveSilentAccountConfig'
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
            ValueName = 'SilentAccountConfig'
            ValueType = 'DWord'
            ValueData = '1'
        }

        Registry 'KFMSilentOptIn'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'KFMSilentOptIn'
          ValueType = 'String'
          ValueData = '5beaf2d2-1c08-4dd5-8630-e5ab67efedde'
        }
        Registry 'KFMSilentOptInWithNotification'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'KFMSilentOptInWithNotification'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'KFMSilentOptInDesktop'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'KFMSilentOptInDesktop'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'KFMSilentOptInDocuments'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'KFMSilentOptInDocuments'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'KFMSilentOptInPictures'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'KFMSilentOptInPictures'
          ValueType = 'DWord'
          ValueData = '1'
        }
        Registry 'KFMOptInWithWizard'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'KFMOptInWithWizard'
          ValueType = 'String'
          ValueData = '5beaf2d2-1c08-4dd5-8630-e5ab67efedde'
        }
        Registry 'SyncAdminReports'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'SyncAdminReports'
          ValueType = 'String'
          ValueData = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL2lkZW50aXR5L2NsYWltcy90ZW5hbnRpZCI6IjViZWFmMmQyLTFjMDgtNGRkNS04NjMwLWU1YWI2N2VmZWRkZSIsImFwcGlkIjoiM2NmNmRmOTItMjc0NS00ZjZmLWJiY2YtMTliNTliY2RiNjJhIiwiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.XO-Cj32kpqjqnyOBmIeo0uc97WK_3rO3Tz6UttCC6fo'
        }
        Registry 'FilesOnDemandEnabled'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\OneDrive'
          ValueName = 'FilesOnDemandEnabled'
          ValueType = 'DWord'
          ValueData = '1'
        }

        # Power Settings Configuration
        Registry 'PowerSettingsACSettingIndex'
        {
            Ensure = 'Present'
            Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\29F6C1DB-86DA-48C5-9FDB-F2B67B1F44DA'
            ValueName = 'ACSettingIndex'
            ValueType = 'DWord'
            ValueData = '0'
        }

        Registry 'ACSettingIndex1'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\7bc4a2f9-d8fc-4469-b07b-33eb785aaca0'
          ValueName = 'ACSettingIndex'
          ValueType = 'DWord'
          ValueData = '0'
        }
        Registry 'ACSettingIndex2'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364'
          ValueName = 'ACSettingIndex'
          ValueType = 'DWord'
          ValueData = '0'
        }
        Registry 'ACSettingIndex3'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\abfc2519-3608-4c2a-94ea-171b0ed546ab'
          ValueName = 'ACSettingIndex'
          ValueType = 'DWord'
          ValueData = '0'
        }
        Registry 'ACSettingIndex4'
        {
          Ensure = 'Present'
          Key = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\B7A27025-E569-46c2-A504-2B96CAD225A1'
          ValueName = 'ACSettingIndex'
          ValueType = 'DWord'
          ValueData = '1'
        }
    }
}

# Executing the configuration
# Microsoft_Windows_10_Enterprise_21H1_CIS_L1_with_LAPS
# Start-DscConfiguration -Path '.\Microsoft_Windows_10_Enterprise_21H1_CIS_L1_with_LAPS' -Verbose -Wait

CompositeConfiguration
# Start-DscConfiguration -Path '.\CompositeConfiguration' -Verbose -Wait
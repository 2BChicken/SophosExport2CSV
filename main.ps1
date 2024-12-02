$Path = "Insert Path to entities.xml"
#
[xml]$XMLObj = Get-Content -Path $Path -Encoding UTF8
#List all Elements in XMLDoc
#$XMLObj.DocumentElement
$PWD = ""
#Set the export target for the csv files

#Listing of IPHosts
$IPHosts = $XMLObj.Configuration.IPHost

if (Test-Path "$($PWD)\IPHosts.csv"){
    Write-Host "File already exists. Please delete it"
}
else{
$list =@()
forEach($IPHost in $IPHosts){
    switch($IPHost.HostType){
        'IP'{
        $Type_Host = $IPHost.HostType
        $Name_Host = $IPHost.Name
        $IPFamily = $IPHost.IPFamily
        $IPAddress = $IPHost.IPAddress
        $StartIPAddress = ''
        $EndIPAddress = ''
        $Subnet = ''
        }
        'Network'{
        $Type_Host = $IPHost.HostType
        $Name_Host = $IPHost.Name
        $IPFamily = $IPHost.IPFamily
        $IPAddress = $IPHost.IPAddress
        $StartIPAddress = ''
        $EndIPAddress = ''
        $Subnet = $IPHost.Subnet
        }
        'IPRange'{
        $Type_Host = $IPHost.HostType
        $Name_Host = $IPHost.Name
        $IPFamily = $IPHost.IPFamily
        $IPAddress = ''
        $StartIPAddress = $IPHost.StartIPAddress
        $EndIPAddress = $IPHost.EndIPAddress
        $Subnet = ''
        }
        'IPList'{}
        'System Host'{}
    }



    $Props =[ordered]@{
        HostType = $Type_Host;
        Name = $Name_Host;
        IPFamily = $IPFamily;
        IP_Address = $IPAddress;
        StartIPAddress = $StartIPAddress;
        EndIPAddress = $EndIPAddress;
        Subnet = $Subnet
    }
    $object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\IPHosts.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

#Listing of $FQDNHost
$FQDNHosts = $XMLObj.Configuration.FQDNHost
if (Test-Path "$($PWD)\FQDNHost.csv"){
Write-Host "File already exists. Please delete it"
}
else {
$list =@()
forEach($FQDNHost in $FQDNHosts){
    $Name_FQDN=$FQDNHost.Name
    $FQDN = $FQDNHost.FQDN
    $Props =[ordered]@{
        Name = "$Name_FQDN";
        FQDN = $FQDN
    }
    $object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\FQDNHost.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

#Listing of $GateWayHost
$GateWayHosts = $XMLObj.Configuration.GatewayHost
if(Test-Path "GateWayHost.csv"){
Write-Host "File already exists. Please delete it"
}
else{
$list =@()
ForEach($GateWayHost in $GateWayHosts){
    $Props = [ordered]@{
    Name = $GateWayHost.Name;
    IPFamily = $GateWayHost.IPFamily;
    GatewayIP = $GateWayHost.GatewayIP;
    Interface = IF($GateWayHost.Interface -eq '') {''};
    NATPolicy = IF($GateWayHost.NATPolicy -eq '') {''};
    Healthcheck = $GateWayHost.Healthcheck;
    MailNotification= $GateWayHost.MailNotification;
    }
$object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\GateWayHost.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

#Listing of $Services
$Services = $XMLObj.Configuration.Services
if(Test-Path "$($PWD)\Services.csv"){
Write-Host "File already exists. Please delete it"
}
else{
$list =@()
ForEach($Service in $Services){
    switch($Service.Type){
    'TCPorUDP'{

        $ServiceName = $Service.Name
        $ServiceType =$Service.Type
        $ListServiceDetails=@()
        IF($Service.ServiceDetails.ChildNodes.Count -gt 1 -and $Service.ServiceDetails.ChildNodes.Count -lt 3 ){
            ForEach($ServiceDetail in $Service.ServiceDetails.ServiceDetail){
                $ListServiceDetails += "$($ServiceDetail.DestinationPort,$ServiceDetail.SourcePort,$ServiceDetail.Protocol)"
            }
            $ServiceDetails_Rule =$ListServiceDetails

        }
    else{
        $ServiceDetails_Rule = "$($ServiceDetail.DestinationPort,$ServiceDetail.SourcePort,$ServiceDetail.Protocol)"
    }


        $ServiceDetails_ProtocolName=''
        $ServiceDetails_ICMPType =''
        $ServiceDetails_ICMPCode =''
        }
    'IP'{
        $ServiceName = $Service.Name
        $ServiceType =$Service.Type
        $ServiceDetails_Rule =''
        $ServiceDetails_ProtocolName=$Service.ServiceDetails.ServiceDetail.ProtocolName
        $ServiceDetails_ICMPType =''
        $ServiceDetails_ICMPCode =''
    }
    'ICMP'{
        $ServiceName = $Service.Name
        $ServiceType =$Service.Type
        $ServiceDetails_Rule =''
        $ServiceDetails_ProtocolName=''
        $ServiceDetails_ICMPType =$Service.ServiceDetails.ServiceDetail.ICMPType
        $ServiceDetails_ICMPCode =$Service.ServiceDetails.ServiceDetail.ICMPCode
    }
    }
    $Props = [ordered]@{
    Name = $ServiceName;
    Type = $ServiceType;
    ServiceDetails_Rule = ($ServiceDetails_Rule-join',')
    ServiceDetails_ProtocolName = $ServiceDetails_ProtocolName;
    ServiceDetails_ICMPType =$ServiceDetails_ICMPType;
    ServiceDetails_ICMPCode =$ServiceDetails_ICMPCode;
    }
$object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\Services.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

#Listing of $Certificates
$Certificates = $XMLObj.Configuration.GatewayHost
if(Test-Path "$($PWD)\Certificate.csv"){
Write-Host "File already exists. Please delete it"
}
else{
$list =@()
ForEach($Certificate in $Certificates){
    $Props = [ordered]@{
    Name = $Certificate.Action;
    IPFamily = $Certificate.Name;
    GatewayIP = $Certificate.Password;
    Interface = $Certificate.CertificateFormat;
    NATPolicy = $Certificate.CertificateFile;
    Healthcheck = $GateWayHost.Healthcheck;
    MailNotification= $GateWayHost.MailNotification;
    }
$object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\Certificate.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

#Listing of $VPNProfile
$VPNProfiles = $XMLObj.Configuration.VPNProfile
if(Test-Path "VPNProfile.csv"){
Write-Host "File already exists. Please delete it"
}
else{
$list =@()
ForEach($VPNProfile in $VPNProfiles){

    ##
    $Props = [ordered]@{
    Name = $VPNProfile.Name;
    Description = $VPNProfile.Description;
    KeyingMethod = $VPNProfile.KeyingMethod;
    AllowReKeying = $VPNProfile.AllowReKeying;
    KeyNegotiationTries =$VPNProfile.KeyNegotiationTries;
    AuthenticationMode = $VPNProfile.AuthenticationMode;
    PassDataInCompressedFormat = $VPNProfile.PassDataInCompressedFormat;
    #$VPNProfile.Phase1
        Phase1_EncryptionAlgorithm1 = $VPNProfile.Phase1.EncryptionAlgorithm1;
        Phase1_AuthenticationAlgorithm1 = $VPNProfile.Phase1.AuthenticationAlgorithm1;
        Phase1_EncryptionAlgorithm2 = $VPNProfile.Phase1.EncryptionAlgorithm2;
        Phase1_AuthenticationAlgorithm2 = $VPNProfile.Phase1.AuthenticationAlgorithm2;
        Phase1_EncryptionAlgorithm3 = $VPNProfile.Phase1.EncryptionAlgorithm3;
        Phase1_AuthenticationAlgorithm3 = $VPNProfile.Phase1.AuthenticationAlgorithm3;
        #$VPNProfile.Phase1.SupportedDHGroups
            Phase1_SupportedDHGroups_DHGroup=$VPNProfile.Phase1.SupportedDHGroups.DHGroup;
        Phase1_KeyLife = $VPNProfile.Phase1.KeyLife;
        Phase1_ReKeyMargin = $VPNProfile.Phase1.ReKeyMargin;
        Phase1_RandomizeReKeyingMarginBy=$VPNProfile.Phase1.'RandomizeRe-KeyingMarginBy';
        Phase1_DeadPeerDetection = $VPNProfile.Phase1.DeadPeerDetection;
        Phase1_CheckPeerAfterEvery = $VPNProfile.Phase1.CheckPeerAfterEvery;
        Phase1_WaitForResponseUpto = $VPNProfile.Phase1.WaitForResponseUpto;
        Phase1_ActionWhenPeerUnreachable = $VPNProfile.Phase1.ActionWhenPeerUnreachable;
    #$VPNProfile.Phase2
        P2_EncryptionAlgorithm1 = $VPNProfile.Phase2.EncryptionAlgorithm1;
        P2_AuthenticationAlgorithm1 = $VPNProfile.Phase2.AuthenticationAlgorithm1;
        P2_EncryptionAlgorithm2 = $VPNProfile.Phase2.EncryptionAlgorithm2;
        P2_AuthenticationAlgorithm2 = $VPNProfile.Phase2.AuthenticationAlgorithm2;
        P2_EncryptionAlgorithm3 = $VPNProfile.Phase2.EncryptionAlgorithm3;
        P2_AuthenticationAlgorithm3 = $VPNProfile.Phase2.AuthenticationAlgorithm3;
        P2_PFSGroup = $VPNProfile.Phase2.PFSGroup;
        P2_KeyLife = $VPNProfile.Phase2.KeyLife;
    sha2_96_truncate = $VPNProfile.sha2_96_truncate;
    keyexchange = $VPNProfile.keyexchange
    }
$object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\VPNProfile.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

#Listing of $SSLTunnelAccessSettings
$SSLTunnelAccessSettings = $XMLObj.Configuration.SSLTunnelAccessSettings
$SSLTunnelAccessSettings.Node

if(Test-Path "$($PWD)\SSLTunnelAccessSettings.csv"){
Write-Host "File already exists. Please delete it"
}
else{
$list =@()
ForEach($SSLTunnelAccessSetting in $SSLTunnelAccessSettings){

    ##
    $Props = [ordered]@{
  Protocol = $SSLTunnelAccessSetting.Protocol;
  SSLServerCertificate = $SSLTunnelAccessSetting.SSLServerCertificate;
  OverrideHostName = $SSLTunnelAccessSetting.OverrideHostName;
  Port=$SSLTunnelAccessSetting.Port;
  #$SSLTunnelAccessSetting.IPLeaseRange
      IPLeaseRange_StartIP=$SSLTunnelAccessSetting.IPLeaseRange.StartIP;
  SubnetMask=$SSLTunnelAccessSetting.SubnetMask;
  IPv6Lease=$SSLTunnelAccessSetting.IPv6Lease;
  IPv6Prefix=$SSLTunnelAccessSetting.IPv6Prefix;
  LeaseMode=$SSLTunnelAccessSetting.LeaseMode;
  PrimaryDNSIPv4=$SSLTunnelAccessSetting.PrimaryDNSIPv4;
  SecondaryDNSIPv4=$SSLTunnelAccessSetting.SecondaryDNSIPv4;
  PrimaryWINSIPv4=$SSLTunnelAccessSetting.PrimaryWINSIPv4;
  SecondaryWINSIPv4=$SSLTunnelAccessSetting.SecondaryWINSIPv4;
  DomainName=$SSLTunnelAccessSetting.DomainName;
  DisconnectDeadPeerAfter=$SSLTunnelAccessSetting.DisconnectDeadPeerAfter;
  DisconnectIdlePeerAfter=$SSLTunnelAccessSetting.DisconnectIdlePeerAfter;
  EncryptionAlgorithm=$SSLTunnelAccessSetting.EncryptionAlgorithm;
  AuthenticationAlgorithm=$SSLTunnelAccessSetting.AuthenticationAlgorithm;
  Keysize=$SSLTunnelAccessSetting.Keysize;
  KeyLifetime=$SSLTunnelAccessSetting.KeyLifetime;
  CompressSSLVPNTraffic=$SSLTunnelAccessSetting.CompressSSLVPNTraffic;
  DebugModeDisable=$SSLTunnelAccessSetting.DebugModeDisable;
  SecurityHeartbeatDisable=$SSLTunnelAccessSetting.SecurityHeartbeatDisable;
  SaveCredentialDisable=$SSLTunnelAccessSetting.SaveCredentialDisable;
  TwoFATokenDisable=$SSLTunnelAccessSetting.TwoFATokenDisable;
  AdLogonDisable=$SSLTunnelAccessSetting.AdLogonDisable;
  AutoConnectDisable=$SSLTunnelAccessSetting.AutoConnectDisable;
  HostorDNSName=$SSLTunnelAccessSetting.HostorDNSName;
  StaticIPAddressesDisable=$SSLTunnelAccessSetting.StaticIPAddressesDisable;
    }
$object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\SSLTunnelAccessSettings.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

#Listing of $SSLVPNPolicy
$SSLVPNPolicys = $XMLObj.Configuration.SSLVPNPolicy

if(Test-Path "$($PWD)\SSLVPNPolicy.csv"){
Write-Host "File already exists. Please delete it"
}
else{
$list =@()
ForEach($SSLVPNPolicy in $SSLVPNPolicys){
    $ListRessource= @()
    ForEach($element in $SSLVPNPolicy.TunnelPolicy.PermittedNetworkResourcesIPv4){
    $ListRessource+=$element.Resource
    }
    ##
    $Props = [ordered]@{
    Name = $SSLVPNPolicy.TunnelPolicy.Name;
    Description=$SSLVPNPolicy.TunnelPolicy.Description;
    UseAsDefaultGateway=$SSLVPNPolicy.TunnelPolicy.UseAsDefaultGateway;
    Ressources=($ListRessource -join',');
    DisconnectIdleClients=$SSLVPNPolicy.TunnelPolicy.DisconnectIdleClients;
    OverrideGlobalTimeout=$SSLVPNPolicy.TunnelPolicy.OverrideGlobalTimeout;
    }
$object = New-Object PSObject -Property $Props
    $list += $object
            }
$list | Export-Csv -Path "$($PWD)\SSLVPNPolicy.csv" -NoTypeInformation -Delimiter "," -Encoding UTF8
}

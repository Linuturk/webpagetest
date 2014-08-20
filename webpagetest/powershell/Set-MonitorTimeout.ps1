$CurrentVal = POWERCFG /QUERY SCHEME_BALANCED SUB_VIDEO VIDEOIDLE | Select-String -pattern "Current AC Power Setting Index:"

If ($CurrentVal -eq "Current AC Power Setting Index: 0x00000000") {
  Write-Output "changed=no comment='Display Timeout already set to Never.'"
} Else {
  POWERCFG /CHANGE -monitor-timeout-ac 0
  Write-Output "changed=yes comment='Display Timeout set to Never.'"
}

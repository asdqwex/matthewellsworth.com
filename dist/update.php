<?PHP

#error_reporting(0);

$secret = 'tDRzWj4DH5845hDVFNASKwRM';

list($algo, $hash) = explode('=', $_SERVER['HTTP_X_HUB_SIGNATURE']);
$payload = file_get_contents('php://input');
$data = json_decode($payload);

$payloadHash = hash_hmac($algo, $payload, $secret);

if ($hash !== $payloadHash) {
  header("HTTP/1.0 404 Not Found");
  exit;
}

exec("sudo salt-call --local state.highstate 2>&1", $output);

print_r($output);

?>

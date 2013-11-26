<?php
$dbhost = 'localhost';
$dbuser = 'root';
$dbpass = 'pass';
$dbname = 'vjoin_dev';
$table = 'questions';
$file = "questions";

$conn = mysql_connect($dbhost, $dbuser, $dbpass) or die ('Error connecting to mysql');
mysql_select_db($dbname);

$fp = fopen($file, "r");
$data = fread($fp, filesize($file));
fclose($fp);
$output = explode("\n", $data);
$myFile = "output2.txt";
$fh = fopen($myFile, 'w') or die("can't open file");

foreach($output as $var) {
  $tmp = explode("\t", $var);
	$title = $tmp[0];
	$c1 = $tmp[1];
	$c2 = $tmp[2];
	$c3 = $tmp[3];
	$c4 = $tmp[4];
	$correct_index = 0;
	$explanation = $tmp[5];
	$type = $tmp[6];
	if ($tmp[1]) {
	$sql = "INSERT INTO $table SET title='$title', c1='$c1', c2='$c2', c3='$c3', c4='$c4', explanation='$explanation', correct_index=$correct_index, created_at=now(), updated_at=now()";
	fwrite($fh, $sql);
	echo $sql;
	mysql_query($sql);
	}
}
fclose($fh);
mysql_close($conn);
?>

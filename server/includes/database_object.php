<?php require_once("initialize.php"); 

class DatabseObject {
	// protected static $table_name;

	// public static function attributes() { 
	// 	// return an array of attribute names and their values
	// 	$attributes = array();
	// 	// $child_class = get_called_class();
	// 	// echo $child_class;
		
	// 	$table_name = $this->table_name;
	// 	echo "Table name:".$table_name;
	// 	foreach($this->$db_fields as $field) {
	// 		echo $field;
	// 		if(property_exists($this, $field)) {
				
	// 			$attributes[$field] = static::$field;
	// 		}
	// 	}
	// 	return $attributes;
	// }

	// public static function sanitized_attributes() {
	// 	global $database;
	// 	$clean_attributes = array();

	// 	// sanitize the values before submitting
	// 	// Note: does not alter the actual value of each attribute
	// 	foreach(self::attributes() as $key => $value){
	// 		$clean_attributes[$key] = $database->escape_value($value);
	// 	}
	// 	return $clean_attributes;
	// }

	public static function json_response($cmd, $err, $data = array(), $log = "") {
		$jasonArray 		= array();
		$jasonArray['cmd'] 	= $cmd;
		$jasonArray['err'] 	= $err;
		$jasonArray['data'] = $data;
		$jasonArray['log'] 	= $log;
		echo json_encode($jasonArray);
	}
}
?>
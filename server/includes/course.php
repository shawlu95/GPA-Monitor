<?php require_once("initialize.php"); 

header('Content-Type: text/html; charset=utf-8');

Class Course {
	protected static $table_name="courses";
	protected static $db_fields = array('id', 'grade', 'credit', 'name', 'term', 'year', 'major', 'majorStr', 'userID', 'created', 'lastModified', 'deleted');

	public $id;
	public $grade;
	public $credit;
	public $name;
	public $term;
	public $year;
	public $major;
	public $majorStr;
	public $userID;
	public $created;
	public $lastModified;
	public $deleted;

	public static function instantiate($record) {
		$object = new self;
		foreach($record as $attribute=>$value){
			if($object->has_attribute($attribute)) {
				$object->$attribute = $value;
			}
		}
		return $object;
	}

	private function has_attribute($attribute) {
	  // We don't care about the value, we just want to know if the key exists
	  // Will return true or false
	  return array_key_exists($attribute, $this->attributes());
	}

	protected function non_null_attributes() {
		$non_null_attributes = array();
		foreach($this->sanitized_attributes() as $key => $value){
			// Only add atrtibute if the value exists, otherwise, phpMyAdmin applies default attribute
			if ($value) {
				$non_null_attributes[$key] = $value;
			}
		}
		return $non_null_attributes;
	}

	protected function attributes() { 
		// return an array of attribute names and their values
		$attributes = array();
		foreach(self::$db_fields as $field) {
			if(property_exists($this, $field)) {
				$attributes[$field] = $this->$field;
			}
		}
		return $attributes;
	}

	protected function sanitized_attributes() {
		global $database;
		$clean_attributes = array();
		// sanitize the values before submitting
		// Note: does not alter the actual value of each attribute
		foreach($this->attributes() as $key => $value){
			$clean_attributes[$key] = $database->escape_value($value);
		}
		return $clean_attributes;
	}

	public static function find_by_sql($sql="") {
		global $database;
		$result_set = $database->query($sql);
		$object_array = array();
		while ($row = $database->fetch_array($result_set)) {
			$object_array[] = self::instantiate($row);
		}
		return $object_array;
	}

	// By using "non_null_attributes", only attribuets with values are saved,
	// attribtues with no values are set to default values.
	public function create () {
		global $database;
		$this->lastModified = date("Y-m-d H:i:s");
		$this->created = date("Y-m-d H:i:s");
		$attributes = $this->attributes();
		$sql = "INSERT INTO ".self::$table_name." (";
		$sql .= join(", ", array_keys($attributes));
		$sql .= ") VALUES ('";
		$sql .= join("', '", array_values($attributes));
		$sql .= "')";
		if($database->query($sql)) {
			$this->id = $database->insert_id();
			return true;
		} else {
			return false;
		}
	}

	// By using "non_null_attributes", only attribuets with values are saved,
	// this ensure that attribteus with defaults values are not erased.
	public function update() {
		global $database;
		$this->lastModified = date("Y-m-d H:i:s");
		$attribute_pairs = array();
		$attributes = $this->attributes();
		foreach($attributes as $key => $value) {
			$attribute_pairs[] = "{$key}='{$value}'";
		}
		$sql = "UPDATE ".self::$table_name." SET ";
		$sql .= join(", ", $attribute_pairs);
		$sql .= " WHERE id=". $database->escape_value($this->id);
		$database->query($sql);
		return ($database->affected_rows() == 1) ? true : false;
	}

	// Prepare the obejct as a JSON representation, with null attribuet removed,
	// in order to minimize the size of the response body.
	public function stripped_array() {
		$array = array();
		$attributes = $this->attributes();
		foreach($attributes as $key => $value) {
			$array[$key] = $value;
		}
		return $array;
	}

	public static function find_by_id($id) {
	    $result_array = self::find_by_sql("SELECT * FROM ".self::$table_name." WHERE id={$id} LIMIT 1;");
		return !empty($result_array) ? array_shift($result_array) : false;
	}

	public function delete() {
		global $database;
		$this->lastModified = date("Y-m-d H:i:s");
		$this->deleted = 1;
		$this->update();
	}

	public function exist() {
		$result_array = self::find_by_id($this->id);
		return !empty($result_array) ? true : false;
	}
	// reusable methods end 
	public static function find_for_username($userID) {
		return self::find_by_sql("SELECT * FROM ".self::$table_name." WHERE userID='{$userID}';");
	}

	public static function sync_session($previous_session) {
		global $request;
		$start = $previous_session->start;
		$userID = $previous_session->userID;
		$installationID = $previous_session->installationID;
		$sql = "SELECT * FROM ".self::$table_name." WHERE lastModified>'{$start}' AND userID = '{$userID}';";
		$request->log .= $sql;
		return self::find_by_sql($sql);
	}
}
?>
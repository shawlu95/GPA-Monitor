<?php 
	require_once("../includes/initialize.php");
	header('Content-Type: text/html; charset=utf-8');
	date_default_timezone_set('Europe/Berlin');
	$input 			= json_decode(file_get_contents('php://input'), true);
	$request 		= Request::instantiate($input);
	$api 			= new API();
	$api->handle_command($request->cmd);
	$request->create();

	class API {
		function handle_command($cmd) {
			switch ($cmd) {
				case 'signup'		: $this->signup(); 	return;
				case 'login'		: $this->login(); 	return;
				case 'logout'		: $this->logout(); 	return;
				case 'cPass'		: $this->cPass(); 	return;

				case 'enter'		: $this->enter_app(); 	return;
				case 'sync'			: $this->sync(); 	return;
				case 'exit'			: $this->exit_app(); 	return;

				case 'create'		: $this->create(); 	return;
				case 'update'		: $this->update(); 	return;
				case 'delete'		: $this->delete(); 	return;
			}
		}

		function signup() {
			global $request;
			if (User::find_by_username($request->data["userID"])) {
				$request->err = 1;
				$request->log = "userID exists";
			} else {
				$user = User::instantiate();
				$user->userID = $request->data["userID"];
				$user->hashed_password 	= User::password_encrypt($request->data["password"]);
				$user->create();

				$items = $request->data['courses'];
				$container = array();
				foreach ($items as $item) {
					$instance = Course::instantiate($item);
					$instance->userID = $user->userID;
					$instance->deleted = 0;
					if ($instance->exist()) {
						$instance->update();
					} else {
						$instance->create();
					}
					$container[] = $instance->stripped_array();
				}
				$request->data = $container;
				$request->err = 0;
				$request->log = "Signup success.";
				$request->userID = $user->userID;
			}

			$session = Session::find_by_installationID($request->installationID);
			$session->userID = $request->userID;
			$session->update();
			
			$request->json_response();
		}

		function login() {
			global $request;
			$user = User::find_by_username($request->data["userID"]);
			if ($user) {
				if ($user->password_check($request->data["password"], $user->hashed_password)) {
					$request->log .= "Login success. ";
					$request->data = Course::find_for_username($user->userID);
					$request->err = 0;
					$request->userID = $user->userID;
				} else {
					$request->log .= "Password incorrect. ";
					$request->err = 1;
				} 
			} else {
				$request->log .= "Account does not exist. ";
				$request->err = 2;
			}
			
			$session = Session::find_by_installationID($request->installationID);
			if ($session) {
				$session->userID = $request->userID;
				$session->update();
			}

			$request->json_response();
		}

		function logout() {
			global $request;
			$request->err = 0;
			$request->log = "User logout.";
			$request->json_response();
		}

		function cPass() {
			global $request;
			$user = User::find_by_username($request->userID);
			$user->change_password($request->data["passNew"]);
			$user->update();
			$request->log = "Changed password.";
			$request->err = 0;
			$request->json_response();
		}

		function sync() {
			global $request;

			$courses = $request->data;
			$app_sync = array();
			foreach ($courses as $course) {
				$db_row = Course::find_by_id($course["id"]);
				$db_row->userID = $request->userID;
				if ($course["id"] == 0 || !$db_row) {
					$db_row = Course::instantiate($course);
					$db_row->deleted = 0;
					$db_row->created = $request->time_stamp;
					$db_row->create();
					$app_sync[] = $db_row->stripped_array();
				} else if ($db_row->lastModified > $course["lastModified"]) {
					$app_sync[] = $db_row->stripped_array();
				} else if ($db_row->lastModified <= $course["lastModified"]) {
					$db_row = Course::instantiate($course);
					$db_row->userID = $request->userID;
					$db_row->lastModified = $request->time_stamp;
					if (!$db_row->majorStr) $db_row->majorStr = 'None';
					$db_row->update();
				}
			}

			$request->data = Course::find_for_username($request->userID);
			$request->log .= "Became active.";
			$request->err = 0;
			$request->json_response();
		}

		function enter_app() {
			global $request;
			$session = Session::instantiate();
			$session->installationID = $request->installationID;
			$session->userID = $request->userID;
			$session->start = $request->time_stamp;
			$session->create();

			$request->sessionID = $session->id;
			$request->log = "Became active.";
			$request->err = 0;
		}

		function exit_app() {
			global $request;
			$session = Session::find_by_installationID($request->installationID);
			$session->end = $request->time_stamp;
			$session->update();
			$request->log = "Resign active.";
			$request->err = 0;
		}

		function create() {
			global $request;
			$instance = Course::instantiate($request->data);
			$instance->userID = $request->userID;
			$instance->created = $request->time_stamp;
			$instance->deleted = 0;
			if (!$instance->majorStr) $instance->majorStr = 'None';
			$instance->create();

			$arr [] = $instance->stripped_array();
			$request->data = $arr;
			$request->log = "Inserted course.";
			$request->err = 0;
			$request->json_response();
		}

		function update() {
			global $request;
			$instance = Course::instantiate($request->data);
			$instance->lastModified = $request->time_stamp;
			$instance->userID = $request->userID;
			$instance->deleted = 0;
			$instance->update();
			$request->log = "Updated course.";
			$request->err = 0;
			$request->json_response();
		}

		function delete() {
			global $request;
			$instance = Course::find_by_id($request->data["id"]);
			$instance->lastModified = $request->time_stamp;
			$instance->delete();
			$request->log = "Deleted course.";
			$request->err = 0;
			$request->json_response();
		}
	}
?>
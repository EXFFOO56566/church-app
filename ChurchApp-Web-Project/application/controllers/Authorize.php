<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Authorize extends BaseController {

	public function __construct()
    {
        parent::__construct();
    }

		public function get_secret_key(){
			$key = base64_decode(JWT_KEY);

			$jwt = JWT::encode(
						"1234567",      //Data to be encoded in the JWT
						$key, // The signing key
						'HS512'     // Algorithm used to sign the token
					);
					//$unencodedArray = ['jwt' => $jwt];
					echo $jwt;
		}
}

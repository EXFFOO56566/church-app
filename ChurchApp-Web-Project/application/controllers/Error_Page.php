<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 11/04/2015
 * Time: 15:11
 */
 require APPPATH . '/libraries/BaseController.php';
class Error_Page extends BaseController {
    public function __construct()
    {
        parent::__construct();
    }

    public function index()
  	{
      http_response_code(404);
  		$this->load->view('error_page');
  	}

    public function show_error(){
      http_response_code(404);
      $this->load->view('first_error_page');
    }

    public function no_page(){
      http_response_code(404);
      $this->load->view('error_page');
    }
}

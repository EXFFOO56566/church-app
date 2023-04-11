<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Login extends CI_Controller {

	/**
	 * Index Page for this controller.
	 */
	public function index()
	{
		$this->load->library('session');
		$this->load->helper('url_helper');
		$isLoggedIn = $this->session->userdata('isLoggedIn');

		if(!isset($isLoggedIn) || $isLoggedIn != TRUE)
		{
				$this->load->view('login');
		}
		else
		{
			header('location:dashboard');

		}
	}
	/**
	 * This function used to logged in user
	 */
	public function authenticate()
	{
		  $this->load->model('login_model');
			$this->load->library('session');
			$this->load->library('form_validation');

			$this->form_validation->set_rules('email', 'Email', 'required|trim');
			$this->form_validation->set_rules('password', 'Password', 'required|max_length[32]');

			if($this->form_validation->run() == FALSE)
			{
					$this->index();
			}
			else
			{
					$email = $this->input->post('email');
					$password = $this->input->post('password');

					$result = $this->login_model->authenticate($email, $password);

					if(count((array)$result) > 0)
					{
							foreach ($result as $res)
							{
									$sessionArray = array(
											'userId'        => $res->email,
											'isLoggedIn'    => TRUE
									);

									$this->session->set_userdata($sessionArray);
									redirect('/dashboard');

							}
					}
					else
					{
							$this->session->set_flashdata('error', 'Email or password mismatch');

							redirect('/login');
					}
			}
	}
}

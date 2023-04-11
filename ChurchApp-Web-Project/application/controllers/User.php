<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

/**
 * Class : User (UserController)
 * User Class to control all user related operations
 */
class User extends BaseController
{
    /**
     * This is default constructor of the class
     */
    public function __construct()
    {
        parent::__construct();
        $this->load->model('user_model');
        $this->isLoggedIn();
    }


    public function index()
    {
        $data['userRecords'] = $this->user_model->userListing();
        $this->load->template('admin/listing', $data); // this will load the view file
    }

    public function logout(){
        $this->session->unset_userdata('email');
        $this->session->unset_userdata('isLoggedIn');
        //$this->session->sess_destroy();

      // Redirect to index page
       redirect ( 'login' );
    }

    public function newAdmin()
    {
        $this->load->template('admin/new', []); // this will load the view file
    }

    public function editAdmin($id=0)
    {
        $data['admin'] = $this->user_model->getAdminInfo($id);
        if(count((array)$data['admin'])==0)
        {
            redirect('adminListing');
        }
        $this->load->template('admin/edit', $data); // this will load the view file
    }



    function savenewadmin()
    {
            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('name','Full Name','trim|required|max_length[128]|xss_clean');
            $this->form_validation->set_rules('email','Email','trim|required|xss_clean|max_length[128]');
            $this->form_validation->set_rules('password1','Password','required|max_length[20]');
            $this->form_validation->set_rules('password2','Confirm Password','trim|required|matches[password1]|max_length[20]');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newAdmin');
            }
            else
            {
                $name = ucwords(strtolower($this->input->post('name')));
                $email = $this->input->post('email');
                $password = $this->input->post('password1');

                $userInfo = array(
                    'fullname'       => $name,
                    'email'      => $email,
                    'password'   => getHashedPassword($password)
                );

                $this->user_model->addNewAdmin($userInfo);
                if($this->user_model->status == "ok")
                {
                    $this->session->set_flashdata('success', $this->user_model->message);
                }
                else
                {
                    $this->session->set_flashdata('error', $this->user_model->message);
                }

                redirect('newAdmin');
            }

    }



    function editadmindata()
    {
            $this->load->library('session');
            $this->load->library('form_validation');
            $id = $this->input->post('id');

            $this->form_validation->set_rules('name','Full Name','trim|required|max_length[128]|xss_clean');
            $this->form_validation->set_rules('email','Email','trim|required|xss_clean|max_length[128]');

            if($this->input->post('password1') != ''){
              $this->form_validation->set_rules('password1','Password','required|max_length[20]');
              $this->form_validation->set_rules('password2','Confirm Password','trim|required|matches[password1]|max_length[20]');
            }


            if($this->form_validation->run() == FALSE)
            {
              redirect('editAdmin/'.$id);
            }
            else
            {
                $name = ucwords(strtolower($this->input->post('name')));
                $email = $this->input->post('email');
                $password = $this->input->post('password1');

                $userInfo = array(
                    'fullname'       => $name,
                    'email'      => $email
                );

                if($password!=''){
                  $userInfo['password'] = getHashedPassword($password);
                }

                $this->user_model->editAdmin($userInfo,$id);
                if($this->user_model->status == "ok")
                {
                    $this->session->set_flashdata('success', $this->user_model->message);
                }
                else
                {
                    $this->session->set_flashdata('error', $this->user_model->message);
                }

                redirect('editAdmin/'.$id);
            }

    }


    function deleteAdmin($id=0)
    {
      $this->load->library('session');
      $this->user_model->deleteAdmin($id);
      if($this->user_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->user_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->user_model->message);
      }
      redirect('adminListing');
    }
}

?>

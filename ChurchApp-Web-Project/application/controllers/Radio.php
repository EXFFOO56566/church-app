<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

/**
 * Class : User (UserController)
 * User Class to control all user related operations
 */
class Radio extends BaseController
{
    /**
     * This is default constructor of the class
     */
    public function __construct()
    {
        parent::__construct();
        $this->isLoggedIn();
        $this->load->model('radio_model');
    }


    public function index(){
      $data['radio'] = $this->radio_model->getRadio();
      $this->load->template('radio', $data); // this will load the view file
    }

    function updateRadio(){
        $this->load->library('session');
        $this->load->library('form_validation');

        $data = array('title'=>$this->input->post('title'),'thumbnail'=>$this->input->post('thumbnail'),'stream_url'=>$this->input->post('stream_url'));
        $this->radio_model->updateRadio($data);

        if($this->radio_model->status == "ok"){
            $this->session->set_flashdata('success', $this->radio_model->message);
        }else{
            $this->session->set_flashdata('error', $this->radio_model->message);
        }
        redirect('radio');
    }
}

?>

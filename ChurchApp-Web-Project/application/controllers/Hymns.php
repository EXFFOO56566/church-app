<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Hymns extends BaseController {

	public function __construct(){
        parent::__construct();
				$this->isLoggedIn();
				$this->load->model('hymns_model');
    }

		//rss links methods
		public function hymnsListing(){
        $this->load->template('hymns/listing', []); // this will load the view file
    }

		function getHymns(){
      // Datatables Variables

        $draw = intval($_POST['draw']);
        $start = intval($_POST['start']);
        $length = intval($_POST['length']);
				$columnIndex = $_POST['order'][0]['column']; // Column index
				$columnName = $_POST['columns'][$columnIndex]['data']; // Column name
				$columnSortOrder = $_POST['order'][0]['dir']; // asc or desc
				$searchValue="";
				if(isset($_POST['search']['value'])){
					$searchValue = $_POST['search']['value']; // Search value
				}

				$columnName="";
				if(isset($_POST['columns'][$columnIndex]['data'])){
					$columnSortOrder = $_POST['columns'][$columnIndex]['data']; // Search value
				}

        $columnSortOrder = "ASC";
				if(isset($_POST['order'][0]['dir'])){
					$columnSortOrder = $_POST['order'][0]['dir']; // Search value
				}


        $feeds = $this->hymns_model->adminHymnsListing($columnName,$columnSortOrder,$searchValue,$start, $length);
				$total_feeds = $this->hymns_model->get_total_hymns($searchValue);
        //var_dump($feeds); die;
        $dat = array();

				 $count = $start + 1;
        foreach($feeds as $r) {
					//var_dump($r); die;
          //$title = substr($r->title,0,10 );
          //$content = substr($r->content,0,50 );

             $dat[] = array(
							    $count,
									$r->title,
									'<div class="btn-group btn-group-sm" style="float: none;">'.
									'<a href="'.site_url().'editHymn/'.$r->id.'" type="button" class="tabledit-edit-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="margin-bottom:5px;" class="material-icons list-icon" data-id="'.$r->id.'">create</i></a>'.
									'<button onclick="delete_item(event)" data-type="hymns" data-id="'.$r->id.'" type="button" class="tabledit-delete-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="color:red;margin-bottom:5px;"  class="material-icons list-icon" data-type="hymns" data-id="'.$r->id.'">delete</i></button>'.
									'</div>'
             );
						 $count++;
        }

        $output = array(
             "draw" => $draw,
               "recordsTotal" => $total_feeds,
               "recordsFiltered" => $total_feeds,
               "data" => $dat
          );
        echo json_encode($output);
    }


		public function newHymn(){
        $this->load->template('hymns/new', []); // this will load the view file
    }

    public function editHymn($id=0)
    {

        $data['hymn'] = $this->hymns_model->getHymnInfo($id);

        if(count((array)$data['hymn'])==0)
        {
            redirect('hymnsListing');
        }
        $this->load->template('hymns/edit', $data); // this will load the view file
    }



    function saveNewHymn()
    {

            $this->load->library('session');
            $this->load->library('form_validation');

						$this->form_validation->set_rules('title','Devotional Title','trim|required');
						$this->form_validation->set_rules('content','Devotional Content','trim|required');

            if($this->form_validation->run() == FALSE)
            {
							  $this->session->set_flashdata('error', "Some fields were left empty");
                redirect('newHymn');
            }else {

							$title = $this->input->post('title');
							$content = $this->input->post('content');

							$info = array(
									'title' => $title,
									'content' => $content
							);

							if(!empty($_FILES['thumbnail']['name'])){
								$upload = $this->upload_thumbnail();
								if($upload[0]=='ok'){
									$info['thumbnail'] =  $upload[1];
								}
							}

              $this->hymns_model->addNewHymn($info);
						}

							if($this->hymns_model->status == "ok")
							{
									$this->session->set_flashdata('success', $this->hymns_model->message);
							}
							else
							{
									$this->session->set_flashdata('error', $this->hymns_model->message);
							}
                redirect('newHymn');

    }



    function editHymnData()
    {
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');

			$this->form_validation->set_rules('title','Devotional Title','trim|required');
			$this->form_validation->set_rules('content','Devotional Content','trim|required');

			if($this->form_validation->run() == FALSE)
			{
					$this->session->set_flashdata('error', "Some fields were left empty");
					redirect('editHymn/'.$id);
			}else {

				$title = $this->input->post('title');
				$content = $this->input->post('content');

				$info = array(
						'title' => $title,
						'content' => $content
				);

				if(!empty($_FILES['thumbnail']['name'])){
					$upload = $this->upload_thumbnail();
					if($upload[0]=='ok'){
						$info['thumbnail'] =  $upload[1];
					}
				}

				$this->hymns_model->editHymn($info,$id);
			}

				if($this->hymns_model->status == "ok")
				{
						$this->session->set_flashdata('success', $this->hymns_model->message);
				}
				else
				{
						$this->session->set_flashdata('error', $this->hymns_model->message);
				}

			redirect('editHymn/'.$id);
    }


    function deleteHymn($id=0)
    {
      $this->load->library('session');
      $this->hymns_model->deleteHymn($id);
      if($this->hymns_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->hymns_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->hymns_model->message);
      }
      redirect('hymnsListing');
    }

		public function upload_thumbnail(){
			$path = $_FILES['thumbnail']['name'];
			$ext = pathinfo($path, PATHINFO_EXTENSION);
			$new_name = time().".".$ext;

			$config['file_name'] = $new_name;
			$config['upload_path']          = './uploads/thumbnails';
			$config['max_size']             = 10000;
			$config['allowed_types']        = 'jpg|png|jpeg|PNG';
			$config['overwrite'] = TRUE; //overwrite thumbnail


			//var_dump($config);

			$this->load->library('upload', $config);

			if ( ! $this->upload->do_upload('thumbnail'))
			{
					//$error = array('error' => $this->upload->display_errors());
					return ['error',strip_tags($this->upload->display_errors())];
			}
			else{
					$image_data = $this->upload->data();
					return ['ok',$new_name];
			}
		}

}

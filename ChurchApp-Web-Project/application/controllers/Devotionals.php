<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Devotionals extends BaseController {

	public function __construct(){
        parent::__construct();
				$this->isLoggedIn();
				$this->load->model('devotionals_model');
    }

		//rss links methods
		public function devotionalsListing(){
        $this->load->template('devotionals/listing', []); // this will load the view file
    }

		function getDevotionals(){
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


        $feeds = $this->devotionals_model->adminDevotionalsListing($columnName,$columnSortOrder,$searchValue,$start, $length);
				$total_feeds = $this->devotionals_model->get_total_devotionals($searchValue);
        //var_dump($feeds); die;
        $dat = array();

				 $count = $start + 1;
        foreach($feeds as $r) {
					//var_dump($r); die;
          //$title = substr($r->title,0,10 );
          //$content = substr($r->content,0,50 );

             $dat[] = array(
							    $count,
									$r->date,
									$r->title,
									'<div class="btn-group btn-group-sm" style="float: none;">'.
									'<a href="'.site_url().'editDevotional/'.$r->id.'" type="button" class="tabledit-edit-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="margin-bottom:5px;" class="material-icons list-icon" data-id="'.$r->id.'">create</i></a>'.
									'<button onclick="delete_item(event)" data-type="devotionals" data-id="'.$r->id.'" type="button" class="tabledit-delete-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="color:red;margin-bottom:5px;"  class="material-icons list-icon" data-type="devotionals" data-id="'.$r->id.'">delete</i></button>'.
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


		public function newDevotional(){
        $this->load->template('devotionals/new', []); // this will load the view file
    }

    public function editDevotional($id=0)
    {

        $data['devotional'] = $this->devotionals_model->getDevotionalInfo($id);
        if(count((array)$data['devotional'])==0)
        {
            redirect('devotionalsListing');
        }
        $this->load->template('devotionals/edit', $data); // this will load the view file
    }



    function saveNewDevotional()
    {

            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('date','Devotional Date','trim|required');
						$this->form_validation->set_rules('title','Devotional Title','trim|required');
						$this->form_validation->set_rules('content','Devotional Content','trim|required');

            if($this->form_validation->run() == FALSE)
            {
							  $this->session->set_flashdata('error', "Some fields were left empty");
                redirect('newDevotional');
            }else {

							$date = $this->input->post('date');
							$title = $this->input->post('title');
							$author =$this->input->post('author');
							$bible_reading = $this->input->post('bible_reading');
							$content = $this->input->post('content');
							$studies =$this->input->post('studies');
							$confession =$this->input->post('confession');

							$info = array(
									'date' => $date,
									'title' => $title,
									'author' => $author,
									'bible_reading' => $bible_reading,
									'studies' => $studies,
									'confession' => $confession,
									'content' => $content
							);

							if(!empty($_FILES['thumbnail']['name'])){
								$upload = $this->upload_thumbnail();
								if($upload[0]=='ok'){
									$info['thumbnail'] =  $upload[1];
								}
							}

              $this->devotionals_model->addNewDevotional($info);
						}

							if($this->devotionals_model->status == "ok")
							{
									$this->session->set_flashdata('success', $this->devotionals_model->message);
							}
							else
							{
									$this->session->set_flashdata('error', $this->devotionals_model->message);
							}
                redirect('newDevotional');

    }



    function editDevotionalData()
    {
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');

			$this->form_validation->set_rules('date','Devotional Date','trim|required');
			$this->form_validation->set_rules('title','Devotional Title','trim|required');
			$this->form_validation->set_rules('content','Devotional Content','trim|required');

			if($this->form_validation->run() == FALSE)
			{
					$this->session->set_flashdata('error', "Some fields were left empty");
					redirect('editDevotional/'.$id);
			}else {

				$date = $this->input->post('date');
				$title = $this->input->post('title');
				$author =$this->input->post('author');
				$bible_reading = $this->input->post('bible_reading');
				$content = $this->input->post('content');
				$studies =$this->input->post('studies');
				$confession =$this->input->post('confession');

				$info = array(
						'date' => $date,
						'title' => $title,
						'author' => $author,
						'bible_reading' => $bible_reading,
						'studies' => $studies,
						'confession' => $confession,
						'content' => $content
				);

				if(!empty($_FILES['thumbnail']['name'])){
					$upload = $this->upload_thumbnail();
					if($upload[0]=='ok'){
						$info['thumbnail'] =  $upload[1];
					}
				}

				$this->devotionals_model->editDevotional($info,$id);
			}

				if($this->devotionals_model->status == "ok")
				{
						$this->session->set_flashdata('success', $this->devotionals_model->message);
				}
				else
				{
						$this->session->set_flashdata('error', $this->devotionals_model->message);
				}

			redirect('editDevotional/'.$id);
    }


    function deleteDevotional($id=0)
    {
      $this->load->library('session');
      $this->devotionals_model->deleteDevotional($id);
      if($this->devotionals_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->devotionals_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->devotionals_model->message);
      }
      redirect('devotionalsListing');
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

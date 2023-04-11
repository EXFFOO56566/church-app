<?php
defined('BASEPATH') OR exit('No direct script access allowed');
header('Content-Type: text/html; charset=utf-8');
require APPPATH . '/libraries/BaseController.php';

class Categories extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->isLoggedIn();
				$this->load->model('categories_model');
    }

		public function index(){
        $data['categories'] = $this->categories_model->categoriesListing();
        $this->load->template('categories/listing', $data); // this will load the view file
    }

		public function loadcategories(){
			$categories = $this->categories_model->categoriesListing();
			echo json_encode(array("status" => "ok","categories" => $categories));
		}

		public function newCategory()
    {
        $this->load->template('categories/new', []); // this will load the view file
    }

    public function editCategory($id=0)
    {
        $data['category'] = $this->categories_model->getCategoryInfo($id);
        if(count((array)$data['category'])==0)
        {
            redirect('categoriesListing');
        }
        $this->load->template('categories/edit', $data); // this will load the view file
    }

    function savenewcategory()
    {
            //var_dump($_POST); die;
            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('name','Category Name','trim|required|max_length[128]|xss_clean');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newCategory');
            } if(empty($_FILES['thumbnail']['name'])){
							$this->session->set_flashdata('error', "Thumbnail is empty");
							redirect('newCategory');
						}
            else
            {
							$upload = $this->upload_thumbnail();
							if($upload[0]=='ok'){
								$name = $this->input->post('name');
								$info = array(
										'name' => $name,
										'thumbnail' => $upload[1]
								);
                                //var_dump($info); die;
								$this->categories_model->addNewCategory($info);
								if($this->categories_model->status == "ok")
								{
										$this->session->set_flashdata('success', $this->categories_model->message);
								}
								else
								{
										$this->session->set_flashdata('error', $this->categories_model->message);
								}
							}else{
								$this->session->set_flashdata('error', $upload[1]);
							}
              redirect('newCategory');
            }

    }


    function editCategoryData()
    {
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');
			$this->form_validation->set_rules('name','Category Name','trim|required|max_length[128]|xss_clean');

			if($this->form_validation->run() == FALSE)
			{
					redirect('editCategory/'.$id);
			} else
			{

					$name = $this->input->post('name');
					$info = array(
							'name' => $name
					);

					if(!empty($_FILES['thumbnail']['name'])){
						$upload = $this->upload_thumbnail();

						if($upload[0]=='ok'){
               $info['thumbnail'] = $upload[1];
						}else{
							$this->session->set_flashdata('error', $upload[1]);
							redirect('editCategory/'.$id);
							return;
						}
					}

					$this->categories_model->editCategory($info,$id);
					if($this->categories_model->status == "ok")
					{
							$this->session->set_flashdata('success', $this->categories_model->message);
					}
					else
					{
							$this->session->set_flashdata('error', $this->categories_model->message);
					}
					redirect('editCategory/'.$id);

			}
    }


    function deleteCategory($id=0)
    {
      $this->load->library('session');
      $this->categories_model->deleteCategory($id);
      if($this->categories_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->categories_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->categories_model->message);
      }
      redirect('categoriesListing');
    }

		//sub category methods
		public function subcategoryListing(){
        $data['categories'] = $this->categories_model->subcategoriesListing();
        $this->load->template('subcategories/listing', $data); // this will load the view file
    }

		public function loadsubcategories(){
			$id = 0;
			if(isset($_GET['id'])){
				$id = $_GET['id'];
			}
			$categories = $this->categories_model->subcategoriesListing($id);
			echo json_encode(array("status" => "ok","subcategories" => $categories));
		}

		public function newSubCategory()
    {
			  $data['categories'] = $this->categories_model->categoriesListing();
        $this->load->template('subcategories/new', $data); // this will load the view file
    }

    public function editSubCategory($id=0)
    {
        $data['category'] = $this->categories_model->getSubCategoryInfo($id);
        if(count((array)$data['category'])==0)
        {
            redirect('subcategoryListing');
        }
				$data['categories'] = $this->categories_model->categoriesListing();
        $this->load->template('subcategories/edit', $data); // this will load the view file
    }

    function savenewsubcategory()
    {
            //var_dump($_FILES); die;
            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('name','Sub Category Name','trim|required|xss_clean');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newSubCategory');
            }
            else
            {
							$name = $this->input->post('name');
							$category_id = $this->input->post('category_id');
							$info = array(
									'name' => $name,
									'category_id' => $category_id
							);

							$this->categories_model->addNewSubCategory($info);
							if($this->categories_model->status == "ok")
							{
									$this->session->set_flashdata('success', $this->categories_model->message);
							}
							else
							{
									$this->session->set_flashdata('error', $this->categories_model->message);
							}
              redirect('newSubCategory');
            }

    }


    function editSubCategoryData()
    {
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');
			$this->form_validation->set_rules('name','Sub Category Name','trim|required|xss_clean');

			if($this->form_validation->run() == FALSE)
			{
					redirect('editSubCategory/'.$id);
			} else
			{

					$name = $this->input->post('name');
					$category_id = $this->input->post('category_id');
					$info = array(
							'name' => $name,
							'category_id' => $category_id
					);

					$this->categories_model->editSubCategory($info,$id);
					if($this->categories_model->status == "ok")
					{
							$this->session->set_flashdata('success', $this->categories_model->message);
					}
					else
					{
							$this->session->set_flashdata('error', $this->categories_model->message);
					}
					redirect('editSubCategory/'.$id);

			}
    }


    function deleteSubCategory($id=0)
    {
      $this->load->library('session');
      $this->categories_model->deleteSubCategory($id);
      if($this->categories_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->categories_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->categories_model->message);
      }
      redirect('subcategoryListing');
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

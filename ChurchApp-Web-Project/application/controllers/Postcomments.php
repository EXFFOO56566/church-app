<?php
if(!defined('BASEPATH')) exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Postcomments extends BaseController {

	public function __construct(){
        parent::__construct();
        $this->load->model('postcomments_model');
    }

		function index(){
			echo "hello";
		}

		public function makecomment(){
			$data = $this->get_data();
			$comment = [];
			$total_count = 0;
			if(!empty($data)){
				  $user = isset($data->user)?filter_var($data->user, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $content = isset($data->content)?filter_var($data->content, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $post = isset($data->post)?filter_var($data->post, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($email!="" && $post !="" && $content != ""){
						 $comment = $this->postcomments_model->makeComment($post,$email,$content);
						 $total_count = $this->postcomments_model->get_total_comments($post);
						 $this->check_notify_user($post, "comment", $user, $email);
				  }
			 }
			 echo json_encode(array("status" => $this->postcomments_model->status,"message" => $this->postcomments_model->message,
		 "comment" => $comment, "total_count" => $total_count));
		}

		public function editcomment(){
			$data = $this->get_data();
			$comment = [];
			if(!empty($data)){
				  $content = isset($data->content)?filter_var($data->content, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($content != "" && $id != ""){
						 $comment = $this->postcomments_model->editComment($id,$content);
				  }
			 }
			 echo json_encode(array("status" => $this->postcomments_model->status,"message" => $this->postcomments_model->message,
		 "comment" => $comment));
		}

		public function deletecomment(){
			$data = $this->get_data();
			$comment = [];
			$total_count = 0;
			if(!empty($data)){
					$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$post = isset($data->post)?filter_var($data->post, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($id != ""){
						 $this->postcomments_model->deleteComment($id);
						 $total_count = $this->postcomments_model->get_total_comments($post);
				  }
			 }
			 echo json_encode(array("status" => $this->postcomments_model->status,"message" => $this->postcomments_model->message, "total_count" => $total_count));
		}

		function loadcomments(){
				$data = $this->get_data();
				$results = [];
				$total_count = 0;
				http_response_code(404);
				$id = 0;
				if(isset($data->id)){
          $id = $data->id;
				}

				$post = 0;
				if(isset($data->post)){
          $post = $data->post;
				}

				$this->load->model('postcomments_model');
				$results = $this->postcomments_model->loadcomments($post,$id);
				$has_more = $this->postcomments_model->checkIfpostHasMoreComments($post,$id);
				$total_count = $this->postcomments_model->get_total_comments($post);
				if(count((array)$results)>0){
					http_response_code(200);
				}
       echo json_encode(array("status" => "ok","comments" => $results,"has_more" => $has_more, "total_count" => $total_count));
		}

		public function reportcomment(){
			$data = $this->get_data();
			if(!empty($data)){
				  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $type = isset($data->type)?filter_var($data->type, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$reason = isset($data->reason)?filter_var($data->reason, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($email!="" && $type !="" && $id != ""){
						$this->postcomments_model->reportComment($id,$email,$type,$reason);
				  }
			 }
			 echo json_encode(array("status" => $this->postcomments_model->status,"message" => $this->postcomments_model->message));
		}

		public function reportedcomments(){
			$this->isLoggedIn();
			$data['reports'] = $this->postcomments_model->loadreportedComments();
			//var_dump($data['reports']); die;
	    $this->load->template('reports', $data); // this will load the view file
		}

		public function reportedCommentWarnEmail(){
			$data = $this->get_data();
			$status = "error";
			$msg = "Cant process the requested operation";
			if(!empty($data)){
				  $comment = isset($data->comment)?filter_var($data->comment, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$message = isset($data->message)?filter_var($data->message, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

					if($comment!="" && $email!="" && $message!=""){
						 $subject = "Flagged Comment";
						 $htmlContent = '<p>Hi '.$email.',</p>';
						 $htmlContent .= '<p>We found the comment below offensive<p>';
						 $htmlContent .= '<p>'.base64_decode($comment).'</p><br>';
						  $htmlContent .= '<p>'.$message.'</p><br>';
						 $htmlContent .= '<p>Kind Regards,</p>';
						 $htmlContent .= '<p>Management Team.</p>';
						 $this->sendMail($email,$subject,$htmlContent);
						 $status = "ok";
			 			$msg = "Mail successfully sent to user";
					}
			 }
			 $this->response($status,$msg);
		}


		function deleteReport($id=0){
			$data = $this->get_data();
			if(!empty($data)){
         $id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				 if($id!=0 && $id!=""){
					 $this->postcomments_model->deleteReport($id);
				 }
				 $this->response($this->postcomments_model->status,$this->postcomments_model->message);
			}else{
				$this->load->library('session');
	      $this->postcomments_model->deleteReport($id);
	      if($this->postcomments_model->status == "ok"){
	          $this->session->set_flashdata('success', $this->postcomments_model->message);
	      }else{
	          $this->session->set_flashdata('error', $this->postcomments_model->message);
	      }
	      redirect('reportedcomments');
			}
    }

		public function usercomments()
		{   $this->isLoggedIn();
				$this->load->template('comments', []); // this will load the view file
		}


		function getCommentsAjax(){
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

				//if get variables, get date ranges
				$date1 = isset($_GET['date'])?filter_var($_GET['date'], FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
				$date2 = isset($_GET['date2'])?filter_var($_GET['date2'], FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
				$date_start = 0;
				if($date1!="" || $date1!=0){
					 $date_start = strtotime($date1);
				}
				$date_end = 0;
				if($date2!="" || $date2!=0){
					 $date_end = strtotime($date2);
				}


				$comments = $this->postcomments_model->userComments($columnName,$columnSortOrder,$searchValue,$start, $length,$date_start,$date_end);
				$total_comments = $this->postcomments_model->get_total_users_comments($searchValue,$date_start,$date_end);
				//var_dump($comments); die;
				$dat = array();

				 $count = $start + 1;
				foreach($comments as $r) {
					$publish_status = $r->deleted==0?'publish comment':'unpublish comment';
          $color = $r->deleted==1?'color:purple;':'color:grey;';

						 $dat[] = array(
									$count,
									base64_decode($r->content),
									$r->email,
									$r->type,
									date("Y-m-d",$r->date),
									'<button title="'.$publish_status.'" data-action="publish" data-id="'.$r->id.'" data-deleted="'.$r->deleted.'" onclick="comment_action(event)"  type="button" class="tabledit-edit-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="'.$color.'" data-action="publish" data-deleted="'.$r->deleted.'" style="margin-bottom:5px;" class="material-icons list-icon" data-id="'.$r->id.'">remove_red_eye</i></button>'.
									'<button title="Thrash this comment" data-action="delete" onclick="comment_action(event)" data-id="'.$r->id.'" type="button" class="tabledit-delete-button btn btn-sm btn-default" style="float: none;">'.
									'<i data-action="delete" onclick="comment_action(event)" data-id="'.$r->id.'" style="color:red;margin-bottom:5px;"  class="material-icons list-icon" data-type="audio" data-id="'.$r->id.'">delete</i></button>'
						 );
						 $count++;

				}

				$output = array(
						 "draw" => $draw,
							 "recordsTotal" => $total_comments,
							 "recordsFiltered" => $total_comments,
							 "data" => $dat
					);
				echo json_encode($output);
		}

		function publishComment($id=0){
      $this->load->library('session');
      $this->postcomments_model->publishUnpublishComment($id,1);
      if($this->postcomments_model->status == "ok"){
          $this->session->set_flashdata('success', $this->postcomments_model->message);
      }else{
          $this->session->set_flashdata('error', $this->postcomments_model->message);
      }
      redirect('usercomments');
    }

		function unPublishComment($id=0){
      $this->load->library('session');
      $this->postcomments_model->publishUnpublishComment($id,0);
      if($this->postcomments_model->status == "ok"){
          $this->session->set_flashdata('success', $this->postcomments_model->message);
      }else{
          $this->session->set_flashdata('error', $this->postcomments_model->message);
      }
      redirect('usercomments');
    }

		function thrashUserComment($id=0){
      $this->load->library('session');
      $this->postcomments_model->thrashUserComment($id);
      if($this->postcomments_model->status == "ok"){
          $this->session->set_flashdata('success', $this->postcomments_model->message);
      }else{
          $this->session->set_flashdata('error', $this->postcomments_model->message);
      }
      redirect('usercomments');
    }
}

<?php
if(!defined('BASEPATH')) exit('No direct script access allowed');
header('Content-Type: text/html; charset=utf-8');
require APPPATH . '/libraries/BaseController.php';

class Replies extends BaseController {

	public function __construct(){
        parent::__construct();
        $this->load->model('replies_model');
    }

		public function replycomment(){
			$data = $this->get_data();
			$reply = [];
			$total_count = 0;
			if(!empty($data)){
				  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $content = isset($data->content)?filter_var($data->content, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $comment = isset($data->comment)?filter_var($data->comment, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($email!="" || $media !="" || $content != ""){
						 $reply = $this->replies_model->replyComment($comment,$email,$content);
						 $total_count = $this->replies_model->get_total_replies($comment);
				  }
			 }
			 echo json_encode(array("status" => $this->replies_model->status,"message" => $this->replies_model->message,
		 "comment" => $reply, "total_count" => $total_count));
		}

		public function editreply(){
			$data = $this->get_data();
			$comment = [];
			$total_count = 0;
			if(!empty($data)){
				  $content = isset($data->content)?filter_var($data->content, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($content != "" || $id != ""){
						 $comment = $this->replies_model->editReply($id,$content);
				  }
			 }
			 echo json_encode(array("status" => $this->replies_model->status,"message" => $this->replies_model->message,
		 "comment" => $comment));
		}

		public function deletereply(){
			$data = $this->get_data();
			$comments = [];
			if(!empty($data)){
					$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$comment_id = isset($data->comment)?filter_var($data->comment, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($id != ""){
						 $this->replies_model->deleteReply($id);
						 $total_count = $this->replies_model->get_total_replies($comment_id);
				  }
			 }
			 echo json_encode(array("status" => $this->replies_model->status,"message" => $this->replies_model->message, "total_count" => $total_count));
		}

		function loadreplies(){
				$data = $this->get_data();
				$results = [];
				$total_count = 0;
				http_response_code(404);
				$id = 0;
				if(isset($data->id)){
          $id = $data->id;
				}

				$comment = 0;
				if(isset($data->comment)){
          $comment = $data->comment;
				}

				$this->load->model('replies_model');
				$results = $this->replies_model->loadreplies($comment,$id);
				$has_more = $this->replies_model->checkIfCommentHaveMoreReplies($comment,$id);
				$total_count = $this->replies_model->get_total_replies($comment);
				if(count((array)$results)>0){
					http_response_code(200);
				}
       echo json_encode(array("status" => "ok","comments" => $results,"has_more" => $has_more, "total_count" => $total_count));
		}
}

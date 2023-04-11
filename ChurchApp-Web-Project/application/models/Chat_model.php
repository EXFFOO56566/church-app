<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Chat_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation';
    public $user = "";

    function __construct(){
       parent::__construct();
	  }

    public function getUsersChat($email="null", $count = 0){
      $this->db->select('tbl_chat.*');
      $this->db->from('tbl_chat');
      $this->db->where('email1',$email);
      $this->db->or_where('email2', $email);
      $this->db->order_by('last_message_time','desc');

        if($count!=0){
            $this->db->limit(20,$count);
        }else{
          $this->db->limit(20);
        }

        $query = $this->db->get();
        $result = $query->result();
        foreach ($result as $res) {
          $res->chats = $this->get_chat_messages($res->id, $email,$count);
          $res->unseen = $this->get_unseen_messages($res->id, $email);
          $res->isOnline = $this->getUserOnlineStatus($res->email1==$email?$res->email2:$res->email1);
          $res->partner = $this->getPartner($res->email1==$email?$res->email2:$res->email1);
          $res->lastSeenDate = $this->getUserLastSeenDate($res->email1==$email?$res->email2:$res->email1);
          $res->is_blocked = $this->verifyIfPartnerIsBlocked($email,$res->email1==$email?$res->email2:$res->email1);
          $res->have_more_content = $this->chats_have_more_content($res->id, $email,$count);
        }
        return $result;
     }

     public function get_chat_messages($chat_id, $email,$count){
       //print($chat_id);
       $this->db->select('tbl_chat_messages.*');
       $this->db->from('tbl_chat_messages');
       $this->db->where('chat_id',$chat_id);
       $this->db->where('msg_owner', $email);
       $this->db->order_by('date','desc');
         if($count!=0){
             $this->db->limit(20,$count);
         }else{
           $this->db->limit(20);
         }

         $query = $this->db->get();
         $result = $query->result();
         foreach ($result as $res) {
           if($res->attachment!=""){
              $res->attachment = site_url()."uploads/socials/chats/".$res->attachment;
           }
           if($res->message!=""){
             $res->message = base64_decode($res->message);
           }

         }
         //var_dump($result); die;
         return $result;
     }


     public function checkfornewmessages($email,$date){
       //print($chat_id);
       $this->db->select('tbl_chat_messages.*');
       $this->db->from('tbl_chat_messages');
       $this->db->where('sender !=',$email);
       $this->db->where('msg_owner', $email);
       $this->db->where('date > ', $date);
        $this->db->limit(20);


         $query = $this->db->get();
         $result = $query->result();
         foreach ($result as $res) {
           if($res->attachment!=""){
              $res->attachment = site_url()."uploads/socials/chats/".$res->attachment;
           }
           if($res->message!=""){
             $res->message = base64_decode($res->message);
           }

         }
         //var_dump($result); die;
         return $result;
     }

     public function get_unseen_messages($chat_id,$email){
       $query = $this->db->select("COUNT(*) as num")->where('chat_id',$chat_id)->where('sender !=', $email)->where('msg_owner', $email)->where('seen', 1)->get("tbl_chat_messages");
       $result = $query->row();
       if(isset($result)) return $result->num;
       return 0;
      }

      public function chats_have_more_content($chatid, $email,$count){
        $query = $this->db->select("COUNT(*) as num")->where('chat_id',$chatid)->where('msg_owner', $email)->get("tbl_chat_messages");
        $result = $query->row();
        if(isset($result)){
           $total = $result->num;
           if($total > ($count + 20)){
             return 0;
           }else{
             return 1;
           }
        }
        return 1;
       }


      function getPartner($email){
        $this->db->select('tbl_android_users.*,tbl_user_profile.*');
        $this->db->from('tbl_android_users');
        $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
        $this->db->where('tbl_android_users.email',$email);
        $query = $this->db->get();
        $user = $query->row();
        if($user){
           $user->activated = 1;
           $user->avatar = base_url()."uploads/socials/avatars/".$user->avatar;
           $user->cover_photo = $user->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$user->cover_photo;
          return $user;
        }else{
          return null;
        }
      }

      public function fetch_user_partner_chat($email, $partner){
        $sql = "SELECT * FROM tbl_chat WHERE (email1 = '".$email."' AND email2 = '".$partner."') OR (email1 = '".$partner."' AND email2 = '".$email."')";
        $query = $this->db->query($sql);
        //var_dump($query); die;
        $result = $query->result();

        if($result){
          $res = new stdClass();
          $res = $result[0];
          $res->chats = $this->get_chat_messages($res->id, $email,0);
          $res->unseen = $this->get_unseen_messages($res->id, $email);
          $res->isOnline = $this->getUserOnlineStatus($res->email1==$email?$res->email2:$res->email1);
          $res->partner = $this->getPartner($res->email1==$email?$res->email2:$res->email1);
          $res->lastSeenDate = $this->getUserLastSeenDate($res->email1==$email?$res->email2:$res->email1);
          $res->is_blocked = $this->verifyIfPartnerIsBlocked($email,$res->email1==$email?$res->email2:$res->email1);
          $res->have_more_content = $this->chats_have_more_content($res->id, $email,$count);
          return $res;
        }else{
          return null;
        }

      }

      public function verifyIfPartnerIsBlocked($email, $partner){
        $sql = "SELECT * FROM tbl_blocked_users WHERE blocked_user = '".$partner."' AND blocked_by = '".$email."' ";
        $query = $this->db->query($sql);
        //var_dump($query); die;
        $result = $query->result();
        if($result){
          return 0;
        }else{
          return 1;
        }

      }

      public function get_user_chatID_if_exists($email, $partner){
        $sql = "SELECT * FROM tbl_chat WHERE (email1 = '".$email."' AND email2 = '".$partner."') OR (email1 = '".$partner."' AND email2 = '".$email."')";
        $query = $this->db->query($sql);
        //var_dump($query); die;
        $result = $query->result();

        if($result){
          $res = new stdClass();
          $res = $result[0];
          return $res->id;
        }else{
          return 0;
        }

      }

      function createUsersChatID($info){
        $this->db->trans_start();
        $this->db->insert('tbl_chat', $info);
        $insert_id = $this->db->insert_id();
        $this->db->trans_complete();
        return $insert_id;
      }

      public function updateChatIDLastMessageTime($id,$date){
        $data = ['last_message_time' => $date];
        $this->db->where('id', $id);
        $this->db->update('tbl_chat', $data);
      }

      function saveUserChatConversation($info){
        $this->db->trans_start();
        $this->db->insert('tbl_chat_messages', $info);
        $insert_id = $this->db->insert_id();
        $this->db->trans_complete();
        return $insert_id;
      }

      public function on_seen_conversation($chatid,$email){
        $data = ['seen' => 0];
        $this->db->where('chat_id', $chatid);
        $this->db->where('msg_owner', $email);
        $this->db->update('tbl_chat_messages', $data);
      }




      function getRecipientDetails($email){
        $this->db->select('tbl_android_users.name, tbl_user_profile.email, tbl_user_profile.avatar, tbl_user_profile.cover_photo');
        $this->db->from('tbl_android_users');
        $this->db->join('tbl_user_profile','tbl_user_profile.email=tbl_android_users.email');
        $this->db->where('tbl_android_users.email',$email);
        $query = $this->db->get();
        $user = $query->row();
        if($user){
           $user->avatar = base_url()."uploads/socials/avatars/".$user->avatar;
           $user->cover_photo = $user->cover_photo==""?"":base_url()."uploads/socials/coverphotos/".$user->cover_photo;
          return $user;
        }else{
          return null;
        }
      }

      function getUserLastSeenDate($email){
        $this->db->select('tbl_user_profile.last_seen_date');
        $this->db->from('tbl_user_profile');
        $this->db->where('tbl_user_profile.email',$email);
        $query = $this->db->get();
        $user = $query->row();
        if($user){
          return $user->last_seen_date;
        }else{
          return 0;
        }
      }

      function getUserOnlineStatus($email){
        $this->db->select('tbl_user_profile.online_status');
        $this->db->from('tbl_user_profile');
        $this->db->where('tbl_user_profile.email',$email);
        $query = $this->db->get();
        $user = $query->row();
        if($user){
          return $user->online_status;
        }else{
          return 1;
        }
      }

      public function updateUserOnlineStatus($email, $status){
        $data = ['online_status' => $status, 'last_seen_date' => time()];
        $this->db->where('email', $email);
        $this->db->update('tbl_user_profile', $data);
      }


      public function getUserLastConversation($id){
        //print($chat_id);
        $this->db->select('tbl_chat_messages.*');
        $this->db->from('tbl_chat_messages');
        $this->db->where('id',$id);

        $query = $this->db->get();
        $res = $query->row();
        if($res){
          if($res->attachment!=""){
             $res->attachment = site_url()."uploads/socials/chats/".$res->attachment;
          }
          if($res->message!=""){
            $res->message = base64_decode($res->message);
          }
        }
          //var_dump($result); die;
        return $res;
      }

      function delete_selected_chat_messages($email, $chatid, $msgReciepts)
      {
        $this->db->where('msg_owner', $email);
        $this->db->where('chat_id', $chatid);
        $this->db->where_in('msg_reciept', $msgReciepts);
        $this->db->delete('tbl_chat_messages');
      }

      function clear_user_chat_messages($email, $chatid)
      {
        $this->db->where('msg_owner', $email);
        $this->db->where('chat_id', $chatid);
        $this->db->delete('tbl_chat_messages');
      }

      function blockUser($info){
        $this->db->trans_start();
        $this->db->insert('tbl_blocked_users', $info);
        $insert_id = $this->db->insert_id();
        $this->db->trans_complete();
        return $insert_id;
      }

      function unblockUser($blockedUser,$blockedBy){
        $this->db->where('blocked_user', $blockedUser);
        $this->db->where('blocked_by', $blockedBy);
        $this->db->delete('tbl_blocked_users');
      }

}

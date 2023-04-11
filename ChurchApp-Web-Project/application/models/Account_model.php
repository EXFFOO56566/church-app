<?php
if(!defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

class Account_model extends CI_Model{
    public $status = 'error';
    public $message = 'Error processing requested operation';
    public $user = [];

    public function get_total_users(){
      $query = $this->db->select("COUNT(*) as num")->where('isDeleted',1)->get("tbl_android_users");
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
    }

    public function fetch_android_users($sort_by="date",$query="",$offset = 0){
        $this->db->select('tbl_android_users.*');
        $this->db->from('tbl_android_users');
        $this->db->where('isDeleted',1);
        if($query!=""){
          $this->db->like('name',$query);
        }
        if($sort_by=="date"){
          $this->db->order_by('date','desc');
        }else {
          $this->db->order_by('name','desc');
        }


        if($offset!=0){
            $this->db->limit(20,$offset);
        }else{
          $this->db->limit(20);
        }

        $query = $this->db->get();
        return $query->result();
    }


    function userListing($columnName,$columnSortOrder,$searchValue,$start, $length){
      $this->db->select('tbl_android_users.*');
      $this->db->from('tbl_android_users');
      $this->db->where('isDeleted',1);
      if($searchValue!=""){
          $this->db->like('name', $searchValue);
          $this->db->or_like('email', $searchValue);
      }
      if($columnName!=""){
         $this->db->order_by($columnName, $columnSortOrder);
      }
      $this->db->limit($length,$start);
      $query = $this->db->get();
      return $query->result();
    }

    public function get_total_android_users($searchValue=""){
      if($searchValue==""){
        $query = $this->db->select("COUNT(*) as num")->where('isDeleted',1)->get("tbl_android_users");
      }else{
        $this->db->select("COUNT(*) as num");
        $this->db->from('tbl_android_users');
        $this->db->where('isDeleted',1);
        $this->db->like('name', $searchValue);
        $this->db->or_like('email', $searchValue);
        $query = $this->db->get();
      }
      $result = $query->row();
      if(isset($result)) return $result->num;
      return 0;
   }


   //authenticate user email and password
    public function authenticateUser($email,$password,$packageName){
      //first we verify email exists
    //  $stmt = $this->db->conn_id->prepare("SELECT * FROM tbl_android_users WHERE email=? && isDeleted = 1");
    //  $stmt->execute([$email]);
    //  $user = $stmt->fetch(PDO::FETCH_OBJ);
    $this->db->select('tbl_android_users.*');
    $this->db->from('tbl_android_users');
    $this->db->where('email',$email);
    $this->db->where('login_type',"email");
    $this->db->where('isDeleted',1);
    $query = $this->db->get();
     $user = $query->row();
       if(!$user){
         $this->status = "error";
         $this->message = "email or password does not exist";
       }else{
         //then we verify if password matches the saved hashed password
         if (password_verify($password, $user->password)){
           $this->status = "ok";
           $profile = $this->getUserSocialProfile($user->email);
           if($profile == null){
              $user->activated = 1;
           }else{
             $user->activated = 0;
             $user->avatar = $profile->avatar;
             $user->cover_photo = $profile->cover_photo;
             $user->gender = $profile->gender;
             $user->date_of_birth = $profile->date_of_birth;
             $user->phone = $profile->phone;
             $user->about_me = $profile->about_me;
             $user->location = $profile->location;
             $user->qualification = $profile->qualification;
             $user->facebook = $profile->facebook;
             $user->twitter = $profile->twitter;
             $user->linkdln = $profile->linkdln;
           }
           $this->user = $user;
           if($user->verified == 1){
             //if user have not verified his account, we display message for user to verify his email address
             $this->message = "A verification link was sent to your mail, follow the link to verify your email address.";

           }else{
             //if user have an active subscription plan
             //we query google to fetch accurate subscription details
             if($user->subscribed == 0 && $user->sub_type == 0){
               $this->load->model('subscription_model');
               $this->subscription_model->getSubscriptionData($packageName,$user->subscribe_plan,$user->subscribe_token);
               $user->subscribe_expiry_date = $this->subscription_model->expiry_date;
               $user->subscribed = $this->subscription_model->subscribed;

               $details = array("subscribed"=>$user->subscribed,"subscribe_expiry_date"=>$user->subscribe_expiry_date);
               $this->updateUserSubscription($details,$user->email);
             }
           }
          } else {
            $this->status = "error";
            $this->message = "Fail to authenticate user";
          }
       }
   }

   public function socialLogin($email,$type,$name,$packageName){
   if($this->verifyEmailExists($email,$type) == FALSE){
     $data = array('name' => $name,'email' => $email,'password' => password_hash($type, PASSWORD_DEFAULT),'login_type'=>$type,'verified'=>0,'date' => date('Y-m-d H:i:s'));
     $this->db->trans_start();
     $this->db->insert('tbl_android_users', $data);
     $insertid = $this->db->insert_id();
     $this->db->trans_complete();
   }
   $this->db->select('tbl_android_users.*');
   $this->db->from('tbl_android_users');
   $this->db->where('email',$email);
   $this->db->where('login_type',$type);
   $this->db->where('isDeleted',1);
   $query = $this->db->get();
    $user = $query->row();
      if(!$user){
        $this->status = "error";
        $this->message = "email does not exist or your account have been deleted by the admin.";
      }else{
        $this->status = "ok";
        $this->message = "user authenticated successfully";

        //if user have an active subscription plan
        //we query google to fetch accurate subscription details
        if($user->subscribed == 0){
          $this->load->model('subscription_model');
          $this->subscription_model->getSubscriptionData($packageName,$user->subscribe_plan,$user->subscribe_token);
          $user->subscribe_expiry_date = $this->subscription_model->expiry_date;
          $user->subscribed = $this->subscription_model->subscribed;

          $details = array("subscribed"=>$user->subscribed,"subscribe_expiry_date"=>$user->subscribe_expiry_date);
          $this->updateUserSubscription($details,$user->email);
        }
        $profile = $this->getUserSocialProfile($user->email);
        if($profile == null){
           $user->activated = 1;
        }else{
          $user->activated = 0;
          $user->avatar = $profile->avatar;
          $user->cover_photo = $profile->cover_photo;
          $user->gender = $profile->gender;
          $user->date_of_birth = $profile->date_of_birth;
          $user->phone = $profile->phone;
          $user->about_me = $profile->about_me;
          $user->location = $profile->location;
          $user->qualification = $profile->qualification;
          $user->facebook = $profile->facebook;
          $user->twitter = $profile->twitter;
          $user->linkdln = $profile->linkdln;
        }
        $this->user = $user;
      }
  }


   //function to register and add user email and password to the database
   public function registerUser($name,$email,$password){
     if($this->verifyEmailExists($email,"email") == FALSE){
       //$data = [':name' => $name,':email' => $email,':password' => password_hash($password, PASSWORD_DEFAULT),':date' => date('Y-m-d H:i:s')];
       //$sql = "INSERT INTO tbl_android_users (name, email, password,date) VALUES (:name, :email, :password, :date)";
       //$stmt= $this->db->conn_id->prepare($sql);
       //$stmt->execute($data);
       //$insertid = $this->db->conn_id->lastInsertId();
       $data = array('name' => $name,'email' => $email,'password' => password_hash($password, PASSWORD_DEFAULT),'login_type'=>"email",'date' => date('Y-m-d H:i:s'));
       $this->db->trans_start();
       $this->db->insert('tbl_android_users', $data);
       $insertid = $this->db->insert_id();
       $this->db->trans_complete();

       //echo $insertid; die;
       if ($insertid){
         $this->status = "ok";
         $this->message = "User registered successfully, Check your mail to verify your email address.";
       }else{
         $this->status = "error";
         $this->message = "Cant register user at the moment";
       }
     }else{
       $this->status = "error";
       $this->message = "Email already exists";
     }

   }

   //update user subscription info
      public function updateUserSubscription($info,$email){
        $this->db->where('email', $email);
        $this->db->update('tbl_android_users', $info);
      }

//when user clicks on the link sent to his mail, we update verified value
   public function updateUserVerfication($email){
    //$stmt= $this->db->conn_id->prepare("UPDATE tbl_android_users SET verified=0 WHERE email = ?");
    //$stmt->execute([$email]);
    $data = array(
        'verified' => 0
    );
    $this->db->where('email', $email);
    $this->db->update('tbl_android_users', $data);
   }

//funstion to update user password
   public function updateUserPassword($email,$password){
     //$data = [':email' => $email,':password' => password_hash($password, PASSWORD_DEFAULT)];
     //$sql = "UPDATE tbl_android_users SET password=:password WHERE email=:email";
     //$stmt= $this->db->conn_id->prepare($sql);
     //$stmt->execute($data);
     $data = array(
         'password' => password_hash($password, PASSWORD_DEFAULT)
     );
     $this->db->where('email', $email);
     $this->db->update('tbl_android_users', $data);
   }


//verify email exists in the database
   public function verifyEmailExists($email,$type){
     //$stmt = $this->db->conn_id->prepare("SELECT * FROM tbl_android_users WHERE email=? /*AND isDeleted=1*/");
     //$stmt->execute([$email]);
     //$user = $stmt->fetch(PDO::FETCH_OBJ);
     $this->db->select('tbl_android_users.email');
     $this->db->from('tbl_android_users');
     $this->db->where('email',$email);
     $this->db->where('login_type',$type);
     $query = $this->db->get();
     $row = $query->row();
      if($row){
        return TRUE;
      }
      return FALSE;
   }

//function to delete user
   public function deleteUser($id){
    /* $data = array(
         'isDeleted' => 0
     );
     $this->db->where('id', $id);
     $this->db->update('tbl_android_users', $data);*/
     $this->db->where('id', $id);
     $this->db->delete('tbl_android_users');
     $this->status = 'ok';
     $this->message = 'User was deleted successfully.';
   }

   //function to block/unblock user
      public function blockOrUnblockUser($id,$blocked){
        //$data = [':id' => $id,':blocked' => $blocked];
        //$sql = "UPDATE tbl_android_users SET blocked=:blocked WHERE id=:id";
        //$stmt= $this->db->conn_id->prepare($sql);
        //$stmt->execute($data);
        $data = array(
            'blocked' => $blocked
        );
        $this->db->where('id', $id);
        $this->db->update('tbl_android_users', $data);
        $this->status = 'ok';
        if($blocked==0){
          $this->message = 'User was blocked successfully.';
        }else{
          $this->message = 'User was unblocked successfully.';
        }

      }

      public function updateAndroidUser($id,$action){
        $this->db->where('id', $id);
        $this->db->update('tbl_android_users', $action);
        $this->status = 'ok';
        $this->message = 'Action completed successfully';
      }

      public function get_android_user($id){
          $this->db->select('tbl_android_users.email');
          $this->db->from('tbl_android_users');
          $this->db->where('id',$id);
          $query = $this->db->get();
          return $query->row();
      }

      function get_user_coins($email){
          $this->db->select('tbl_android_users.user_coins');
          $this->db->from('tbl_android_users');
          $this->db->where('email', $email);
          $query = $this->db->get();
          $this->user_coins = $query->row()->user_coins;
      }

      function getUserSocialProfile($email){
        $this->db->select('tbl_user_profile.*');
        $this->db->from('tbl_user_profile');
        $this->db->where('email',$email);
        $query = $this->db->get();
        $user = $query->row();
        if($user){
           $user->avatar = base_url()."uploads/socials/avatars/".$user->avatar;
           $user->cover_photo = base_url()."uploads/socials/coverphotos/".$user->cover_photo;
          return $user;
        }else{
          return null;
        }
      }
}

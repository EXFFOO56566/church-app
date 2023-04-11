<?php if(!defined('BASEPATH')) exit('No direct script access allowed');

class User_model extends CI_Model
{
  public $status = 'error';
  public $message = 'Something went wrong';
  public $new_array = [];

      public function get_total_admin(){
        $query = $this->db->select("COUNT(*) as num")->get("tbl_users");
        $result = $query->row();
        if(isset($result)) return $result->num;
        return 0;
      }

    /**
     * This function is used to get the user listing count
     */
    function userListing()
    {
        $this->db->select('tbl_users.*');
        $this->db->from('tbl_users');
        $query = $this->db->get();
        return $query->result();
    }


    /** This function is used to check whether email id is already exist or not
     * @param {string} $email : This is email id
     * @param {number} $userId : This is user id
     * @return {mixed} $result : This is searched result
     */
    function checkEmailExists($email, $id = 0)
    {
        $this->db->select("email");
        $this->db->from("tbl_users");
        $this->db->where("email", $email);
        if($id != 0){
            $this->db->where("id !=", $id);
        }
        $query = $this->db->get();

        return $query->result();
    }


    /**
     * This function is used to add new admin to system
     * @return number $insert_id : This is last inserted id
     */
    function addNewAdmin($userInfo)
    {
      if(empty($this->checkEmailExists($userInfo['email']))){
        $this->db->trans_start();
        $this->db->insert('tbl_users', $userInfo);
        $insert_id = $this->db->insert_id();
        $this->db->trans_complete();
        $this->status = 'ok';
        $this->message = 'Admin User added successfully';
      }else{
        $this->status = 'error';
        $this->message = 'Email already exists';
      }
    }


    /**
     * This function is used to update the user information
     * @param array $userInfo : This is users updated information
     * @param number $userId : This is user id
     */
    function editAdmin($userInfo, $id){
      if(empty($this->checkEmailExists($userInfo['email'],$id))){
        $this->db->where('id', $id);
        $this->db->update('tbl_users', $userInfo);
        $this->status = 'ok';
        $this->message = 'Admin User edited successfully';
      }else{
        $this->status = 'error';
        $this->message = 'Another user already using this email '.$userInfo['email'];
      }
    }

    /**
     * This function used to get user information by id
     * @param number $userId : This is user id
     * @return array $result : This is user information
     */
    function getAdminInfo($id)
    {
        $this->db->select('tbl_users.*');
        $this->db->from('tbl_users');
        $this->db->where('id', $id);
        $query = $this->db->get();
        return $query->row();
    }


    /**
     * This function is used to delete the user information
     * @param number $userId : This is user id
     * @return boolean $result : TRUE / FALSE
     */
    function deleteAdmin($id){
        $this->db->where('id', $id);
        $this->db->delete('tbl_users');
         $this->status = 'ok';
         $this->message = 'Admin was deleted successfully.';
    }

    /**
     * This function is used to change users password
     * @param number $userId : This is user id
     * @param array $userInfo : This is user updation info
     */
    function changePassword($userId, $userInfo)
    {
        $this->db->where('userId', $userId);
        $this->db->update('tbl_users', $userInfo);

        return $this->db->affected_rows();
    }
}

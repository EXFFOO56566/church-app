<?php
/**
 * Created by PhpStorm.
 * User: ray
 * Date: 12/06/2018
 * Time: 14:29
 */

 // hide notices
 @ini_set('error_reporting', E_ALL & ~ E_NOTICE);

 //- turn off compression on the server
 @apache_setenv('no-gzip', 1);
 @ini_set('zlib.output_compression', 'Off');

class Download_model extends CI_Model{

    function __construct(){
       parent::__construct();
	  }

    public function load($id){
           $this->db->select('tbl_media.source,tbl_media.type');
           $this->db->from('tbl_media');
           $this->db->where('id',$id);

           $query = $this->db->get();
           $row = $query->row();
           if(count((array)$row) > 0){
             if($row->type == "audio"){
               $path = './uploads/audios/'.$row->source;
               $file_ext = "mp3";
             }else{
               $file_ext = "mp4";
               $path = './uploads/videos/'.$row->source;
             }
             $this->serve_file($row->source,$file_ext,$path);
           }else{
             header("HTTP/1.0 400 Bad Request");
             exit;
           }
     }

     private function serve_file($file_name,$file_ext,$file_path){
       // make sure the file exists
       if (is_file($file_path))
       {
         clearstatcache();
         $file_size  = filesize($file_path);
         $file = @fopen($file_path,"rb");
         if ($file)
         {
           // set the headers, prevent caching
           header("Pragma: public");
           header("Expires: -1");
           header("Cache-Control: public, must-revalidate, post-check=0, pre-check=0");
           header("Content-Disposition: attachment; filename=\"$file_name\"");
           header('Last-Modified: '.gmdate('D, d M Y H:i:s', filemtime($file_path)).' GMT', true, 200);

           header('Content-Disposition: inline;');
           header('Content-Transfer-Encoding: binary');

               // set the mime type based on extension, add yours if needed.
               $ctype_default = "application/octet-stream";
               $content_types = array(
                       "mp3" => "audio/mpeg",
                       "mp4" => "video/mp4",
               );
               $ctype = isset($content_types[$file_ext]) ? $content_types[$file_ext] : $ctype_default;
               header("Content-Type: " . $ctype);

          $req_headers = apache_request_headers();

           //check if http_range is sent by browser (or download manager)

           if(isset($req_headers['HTTP_RANGE']))
           {
             list($size_unit, $range_orig) = explode('=', $req_headers['HTTP_RANGE'], 2);

             if ($size_unit == 'bytes')
             {
               //multiple ranges could be specified at the same time, but for simplicity only serve the first range
               //http://tools.ietf.org/id/draft-ietf-http-range-retrieval-00.txt
               list($range, $extra_ranges) = explode(',', $range_orig, 2);
             }
             else
             {
               $range = '';
               header('HTTP/1.1 416 Requested Range Not Satisfiable');
               exit;
             }
           }
           else
           {
             $range = '';
           }

           //$myfile = fopen("./uploads/newfile.txt", "w") or die("Unable to open file!");
           //fwrite($myfile, $range);
           //fclose($myfile);die;

           //figure out download piece from range (if set)
           list($seek_start, $seek_end) = explode('-', $range, 2);

           //set start and end based on range (if set), else set defaults
           //also check for invalid ranges.
           $seek_end   = (empty($seek_end)) ? ($file_size - 1) : min(abs(intval($seek_end)),($file_size - 1));
           $seek_start = (empty($seek_start) || $seek_end < abs(intval($seek_start))) ? 0 : max(abs(intval($seek_start)),0);

           //Only send partial content header if downloading a piece of the file (IE workaround)
           if ($seek_start > 0 || $seek_end < ($file_size - 1))
           {
             header('HTTP/1.1 206 Partial Content');
             header('Content-Range: bytes '.$seek_start.'-'.$seek_end.'/'.$file_size);
             //header('Content-Length: '.($seek_end - $seek_start + 1));
             header("Content-Length: $file_size");
           }
           else
             header("Content-Length: $file_size");

           header('Accept-Ranges: bytes');

           set_time_limit(0);
           fseek($file, $seek_start);

           while(!feof($file))
           {
             print(@fread($file, 1024*8));//8
             ob_flush();
             flush();
             if (connection_status()!=0)
             {
               @fclose($file);
               clearstatcache();
               exit;
             }
           }

           // file save was a success
           @fclose($file);
           clearstatcache();
           exit;
         }
         else
         {
           // file couldn't be opened
           header("HTTP/1.0 500 Internal Server Error");
           exit;
         }
       }
       else
       {
         // file does not exist
         header("HTTP/1.0 404 Not Found");
         exit;
       }
     }
}

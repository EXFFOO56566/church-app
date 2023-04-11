<section class="content">
    <div class="container-fluid">
        <div class="block-header">
          <h2>Update Video</h2>
          <small>You can only update video details</small>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form id="upload-form">
                            <div class="addon-line">

                                <div class="form-line">
                                  <label>Video Category</label>
                                  <select class="form-control" id="category" required="" autofocus="">
                                    <option value="">select category</option>
                                    <?php foreach ($categories as $res) { ?>
                                      <option value="<?php echo $res->id; ?>" <?php echo $video->category_id==$res->id?"selected":""; ?>><?php echo $res->name; ?></option>
                                    <?php  } ?>
                                  </select>
                                </div>
                            </div>
                            <div class="addon-line" style="margin-top:20px;  display:none;">

                                <div class="form-line">
                                  <label>Video SubCategory</label>
                                  <select class="form-control" id="subcategories">
                                    <option value="0">Select Video SubCategory</option>
                                    <?php foreach ($subcategories as $res) { ?>
                                      <option value="<?php echo $res->id; ?>" <?php echo $video->sub_category==$res->id?"selected":""; ?>><?php echo $res->name; ?></option>
                                    <?php  } ?>
                                  </select>
                                </div>
                            </div>
                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Video Title (Users can search for this video using this title)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" id="title" placeholder="Video Title" required="" autofocus="" value="<?php echo $video->title; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                               <label>Video Description (Users can search for this video using this description)</label>
                                <div class="form-line">
                                    <textarea type="text" class="form-control" id="description" placeholder="Video Description" required="" autofocus=""><?php echo $video->description; ?></textarea>
                                </div>
                            </div>

                            <div id="link_div" style="margin-top:20px; display:none;">
                              <div class="input-group addon-line" style="margin-top:20px;">
                                  <label>CoverPhoto Link</label>
                                  <div class="form-line">
                                      <input type="url" class="form-control" id="thumbnail_link" placeholder=" Coverphoto Link" autofocus="" value="<?php echo $video->cover_photo; ?>">
                                  </div>
                              </div>

                              <div class="input-group addon-line" style="margin-top:20px;">
                                     <label id="video-label">Video Link (<?php echo $video->video_type; ?>)</label>

                                  <div class="form-line">
                                      <input type="url" class="form-control" id="media_link" placeholder="Video Link" autofocus="" value="<?php echo $video->source; ?>">
                                  </div>

                              </div>
                            </div>





                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Video Duration (format 00:00)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" id="duration" name="duration" placeholder="Video duration" required="" autofocus="" value="<?php echo $video->duration; ?>">
                                </div>
                            </div>

                              <div class="addon-line" style="display:none;">

                                  <div class="form-line">
                                    <label>Allow users stream this video for free?</label>
                                      <select class="form-control" id="is_free" required="" autofocus="">
                                          <option value="0" <?php echo $video->is_free==0?"selected":""; ?>>YES</option>
                                          <option value="1" <?php echo $video->is_free==1?"selected":""; ?>>NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="addon-line" style="margin-top:20px;">

                                  <div class="form-line">
                                    <label>Allow users download this video to their device? (Not applicable for Youtube,Dailymotion,Vimeo,m3u8 and dash videos)</label>
                                      <select class="form-control" id="can_download" required="" autofocus="">
                                          <option value="0" <?php echo $video->can_download==0?"selected":""; ?>>YES</option>
                                          <option value="1" <?php echo $video->can_download==1?"selected":""; ?>>NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="addon-line" style="margin-top:20px; display:none;">

                                  <div class="form-line">
                                    <label>Allow users preview a few seconds of this video?</label>
                                      <select class="form-control" id="can_preview" required="" autofocus="">
                                          <option value="0" <?php echo $video->can_preview==0?"selected":""; ?>>YES</option>
                                          <option value="1" <?php echo $video->can_preview==1?"selected":""; ?>>NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="input-group addon-line" style="margin-top:20px; display:none;">
                                  <label>How many seconds preview is allowed for this video? (If user cant preview this video, leave default value)</label>
                                  <div class="form-line">
                                      <input type="number" class="form-control" id="preview_duration" placeholder="Preview Duration in seconds" required="" autofocus="" value="<?php echo $video->preview_duration; ?>">
                                  </div>
                              </div>
                              <input type="hidden" id="id" class="form-control" value="<?php echo $video->id; ?>">

                            <div class="box-footer text-center">
                               <button id="submit" onclick="updateVideo(event)" class="btn btn-primary waves-effect" type="submit">UPDATE VIDEO</button>
                               <ol class="breadcrumb align-center" id="loader" style="display:none;">
                                 <li><span style="font-size:18px; color:grey; font-style:italic;" id="publish_hint">Processing Request, Please Wait..</span>
                                   <br>
                                   <div class="preloader pl-size-xs">
                                       <div class="spinner-layer pl-teal">
                                           <div class="circle-clipper left">
                                               <div class="circle"></div>
                                           </div>
                                           <div class="circle-clipper right">
                                               <div class="circle"></div>
                                           </div>
                                       </div>
                                   </div>
                                 </li>
                               </ol>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
            </div>
    </div>
</section>
<script type="text/javascript">
var media_url = "<?php echo $video->source; ?>";
var thumb = "<?php echo $video->cover_photo; ?>";
</script>

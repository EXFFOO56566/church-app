<section class="content">
    <div class="container-fluid">
        <div class="block-header">
            <h2>Add New Video</h2>
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
                                      <option value="<?php echo $res->id; ?>"><?php echo $res->name; ?></option>
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
                                      <option value="<?php echo $res->id; ?>"><?php echo $res->name; ?></option>
                                    <?php  } ?>
                                  </select>
                                </div>
                            </div>
                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Video Title (Users can search for this video using this title)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" id="title" name="title" placeholder="Video Title" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                               <label>Video Description (Users can search for this video using this description)</label>
                                <div class="form-line">
                                    <textarea type="text" class="form-control" id="description" name="description" placeholder="Video Description" required="" autofocus=""></textarea>
                                </div>
                            </div>

                            <div class="addon-line" style="margin-top:20px;">
                                <div class="form-line">
                                  <label>Media Type</label>
                                    <select class="form-control" id="media_type" required="" autofocus="">
                                        <option value="mp4_video" selected>Upload MP4 Video</option>
                                        <option value="video_link">mp4 video link</option>
                                        <option value="youtube_video" >Youtube video id</option>
                                        <option value="vimeo_video" >Vimeo video id</option>
                                        <option value="dailymotion_video" >Dailymotion video id</option>
                                        <option value="mpd_video">mpd video link</option>
                                        <option value="m3u8_video">m3u8 video Link</option>
                                    </select>
                                </div>
                            </div>

                            <div id="upload_div" style="margin-top:20px;">
                              <div class="input-group addon-line">
                                  <label>Video CoverPhoto (Please resize your image before uploading)</label>
                                  <div class="form-line">
                                      <input id="thumbnail" type="file" data-allowed-file-extensions="jpeg jpg png JPEG PNG" class="dropify2" required data-height="100">
                                  </div>
                              </div>

                                <div class="input-group addon-line">

                                    <div class="form-line">
                                        <input id="video-file" type="file" name="mp3" data-allowed-file-extensions="mp4" class="dropify3" required data-height="100">
                                    </div>

                                </div>
                            </div>

                            <div id="link_div" style="margin-top:20px; display:none;">
                              <div class="input-group addon-line" style="margin-top:20px;">
                                  <label>CoverPhoto Link</label>
                                  <div class="form-line">
                                      <input type="url" class="form-control" id="thumbnail_link" placeholder=" Coverphoto Link" autofocus="">
                                  </div>
                              </div>

                              <div class="input-group addon-line" style="margin-top:20px;">
                                     <label id="video-label">Video Link</label>

                                  <div class="form-line">
                                      <input type="url" class="form-control" id="media_link" placeholder="Video Link" autofocus="">
                                  </div>

                              </div>
                            </div>

                            <div class="input-group addon-line" style="display:none;">
                              <div class="form-line">
                                  <input type="text" class="form-control" id="_hd" name="_hd" placeholder="Enter HD Video Link Or Upload File Below">
                              </div>
                                <div class="form-line">
                                    <input id="hd-file" type="file" name="hd" class="dropify4" required data-height="100" data-allowed-file-extensions="*">
                                </div>

                            </div>

                            <div class="input-group addon-line" style="display:none;">
                              <div class="form-line">
                                  <input type="text" class="form-control" id="_sd" name="_sd" placeholder="Enter SD Video Link Or Upload File Below">
                              </div>
                                <div class="form-line">
                                    <input id="sd-file" type="file" name="sd" class="dropify5" required data-height="100" data-allowed-file-extensions="*">
                                </div>

                            </div>

                            <div class="input-group addon-line" style="display:none;">
                              <div class="form-line">
                                  <input type="text" class="form-control" id="_mp3" name="_mp3" placeholder="Enter MP3 Link Or Upload File Below">
                              </div>
                                <div class="form-line">
                                    <input id="mp3-file" type="file" name="mp3" data-allowed-file-extensions="mp3" class="dropify" required data-height="100">
                                </div>

                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Video Duration (format 00:00)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" id="duration" name="duration" placeholder="Video duration" required="" autofocus="">
                                </div>
                            </div>



                              <div class="addon-line" style="margin-top:20px; display:none;">

                                  <div class="form-line">
                                    <label>Allow users stream this video for free? (Not applicable for Youtube,Dailymotion,Vimeo,m3u8 and dash videos)</label>
                                      <select class="form-control" id="is_free" required="" autofocus="">
                                          <option value="0">YES</option>
                                          <option value="1">NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="addon-line" style="margin-top:20px;">

                                  <div class="form-line">
                                    <label>Allow users download this video to their device? (Not applicable for Youtube,Dailymotion,Vimeo,m3u8 and dash videos)</label>
                                      <select class="form-control" id="can_download" required="" autofocus="">
                                          <option value="0">YES</option>
                                          <option value="1">NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="addon-line" style="margin-top:20px; display:none;">

                                  <div class="form-line">
                                    <label>Allow users preview a few seconds of this video?</label>
                                      <select class="form-control" id="can_preview" required="" autofocus="">
                                          <option value="0">YES</option>
                                          <option value="1">NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="input-group addon-line" style="margin-top:20px; display:none;">
                                  <label>How many seconds preview is allowed for this video? (If user cant preview this video, leave default value)</label>
                                  <div class="form-line">
                                      <input type="number" value="120" class="form-control" name="preview_duration" placeholder="Preview Duration in seconds" required="" autofocus="">
                                  </div>
                              </div>

                              <div class="addon-line" style="margin-top:20px;">

                                  <div class="form-line">
                                    <label>Send a broadcast to notify users of this video?</label>
                                      <select class="form-control" id="notify" required="" autofocus="">
                                          <option value="true">YES</option>
                                          <option value="false">NO</option>
                                      </select>
                                  </div>
                              </div>

                            <div class="box-footer text-center" style="margin-top:20px;">
                               <button id="submit" onclick="uploadNewVideo(event)" class="btn btn-primary waves-effect" type="submit">UPLOAD NEW VIDEO</button>

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

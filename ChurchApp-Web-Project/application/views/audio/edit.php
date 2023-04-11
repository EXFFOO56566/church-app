<section class="content">
    <div class="container-fluid">
        <div class="block-header">
          <h2>Edit Audio</h2>
          <small>You can only update audio details</small>
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
                                  <label>Audio Category</label>
                                  <select class="form-control" id="category" required="" autofocus="">
                                    <option value="">select category</option>
                                    <?php foreach ($categories as $res) { ?>
                                      <option value="<?php echo $res->id; ?>" <?php echo $audio->category_id==$res->id?"selected":""; ?>><?php echo $res->name; ?></option>
                                    <?php  } ?>
                                  </select>
                                </div>
                            </div>
                            <div class="addon-line" style="margin-top:20px;  display:none;">

                                <div class="form-line">
                                  <label>Audio SubCategory</label>
                                  <select class="form-control" id="subcategories">
                                    <option value="0">Select Audio SubCategory</option>
                                    <?php foreach ($subcategories as $res) { ?>
                                      <option value="<?php echo $res->id; ?>" <?php echo $audio->sub_category==$res->id?"selected":""; ?>><?php echo $res->name; ?></option>
                                    <?php  } ?>
                                  </select>
                                </div>
                            </div>
                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Audio Title (Users can search for this audio using this title)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" id="title" placeholder="Audio Title" required="" autofocus="" value="<?php echo $audio->title; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                               <label>Audio Description (Users can search for this audio using this description)</label>
                                <div class="form-line">
                                    <textarea type="text" class="form-control" id="description" placeholder="Audio Description" required="" autofocus=""><?php echo $audio->description; ?></textarea>
                                </div>
                            </div>

                            <div id="link_div" style="margin-top:20px; display:none;">
                              <div class="input-group addon-line" style="margin-top:20px;">
                                  <label>CoverPhoto Link</label>
                                  <div class="form-line">
                                      <input type="url" class="form-control" id="thumbnail_link" placeholder=" Coverphoto Link" autofocus="" value="<?php echo $audio->cover_photo; ?>">
                                  </div>
                              </div>

                              <div class="input-group addon-line" style="margin-top:20px;">
                                     <label id="video-label">Audio File Link</label>

                                  <div class="form-line">
                                      <input type="url" class="form-control" id="media_link" placeholder="Audio File Link" autofocus="" value="<?php echo $audio->source; ?>">
                                  </div>

                              </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Audio Duration (format 00:00:00)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" id="duration" name="duration" placeholder="Audio duration" required="" autofocus="" value="<?php echo $audio->duration; ?>">
                                </div>
                            </div>

                              <div class="addon-line" style="margin-top:20px; display:none;">

                                  <div class="form-line">
                                    <label>Allow users stream this audio for free?</label>
                                      <select class="form-control" id="is_free" required="" autofocus="">
                                          <option value="0" <?php echo $audio->is_free==0?"selected":""; ?>>YES</option>
                                          <option value="1" <?php echo $audio->is_free==1?"selected":""; ?>>NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="addon-line" style="margin-top:20px;">

                                  <div class="form-line">
                                    <label>Allow users download this audio to their device? </label>
                                      <select class="form-control" id="can_download" required="" autofocus="">
                                          <option value="0" <?php echo $audio->can_download==0?"selected":""; ?>>YES</option>
                                          <option value="1" <?php echo $audio->can_download==1?"selected":""; ?>>NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="addon-line" style="margin-top:20px; display:none;">

                                  <div class="form-line">
                                    <label>Allow users preview a few seconds of this audio?</label>
                                      <select class="form-control" id="can_preview" required="" autofocus="">
                                          <option value="0" <?php echo $audio->can_preview==0?"selected":""; ?>>YES</option>
                                          <option value="1" <?php echo $audio->can_preview==1?"selected":""; ?>>NO</option>
                                      </select>
                                  </div>
                              </div>

                              <div class="input-group addon-line" style="margin-top:20px; display:none;">
                                  <label>How many seconds preview is allowed for this audio? (If user cant preview this audio, leave default value)</label>
                                  <div class="form-line">
                                      <input type="number" class="form-control" id="preview_duration" placeholder="Preview Duration in seconds" required="" autofocus="" value="<?php echo $audio->preview_duration; ?>">
                                  </div>
                              </div>
                              <input type="hidden" required="" id="id" autofocus="" value="<?php echo $audio->id; ?>">

                            <div class="box-footer text-center">
                               <button id="submit" onclick="updateAudio(event)" class="btn btn-primary waves-effect" type="submit">UPDATE AUDIO</button>
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
var media_url = "<?php echo $audio->source; ?>";
var thumb = "<?php echo $audio->cover_photo; ?>";
</script>

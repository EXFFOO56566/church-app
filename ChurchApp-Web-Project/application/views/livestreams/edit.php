<section class="content">
    <div class="container-fluid">
        <div class="block-header">
          <h2>New LiveStream TV</h2>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>editLivestreamData">
                            <input type="hidden" class="form-control" name="id" value="<?php echo $livestream->id; ?>">

                            <div class="addon-line" style="margin-top:0px;">

                                <div class="form-line">
                                  <label>LiveTv Source</label>
                                    <select class="form-control" name="type" required="" autofocus="">
                                        <option value="m3u8" <?php echo $livestream->type=="m3u8"?"selected":""; ?>>m3u8 Live</option>
                                        <option value="youtube" <?php echo $livestream->type=="youtube"?"selected":""; ?>>Youtube LiveVideo ID</option>
                                        <option value="rtmp" <?php echo $livestream->type=="rtmp"?"selected":""; ?>>rtmp Live</option>
                                    </select>
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>LiveTv Title</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" value="<?php echo $livestream->title; ?>" placeholder="LiveTv Title" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>LiveTv CoverPhoto</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="cover_photo" value="<?php echo $livestream->cover_photo; ?>" placeholder="LiveTv CoverPhoto" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                   <label>LiveTv Link</label>

                                <div class="form-line">
                                    <input type="text" class="form-control" name="source" value="<?php echo $livestream->source; ?>" placeholder="LiveTv Link" autofocus="">
                                </div>

                            </div>


                            <div class="addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                  <label>Allow users watch this livestream for free?(if not free, only subscribed users can watch)</label>
                                    <select class="form-control" name="is_free" required="" autofocus="">
                                        <option value="0" <?php echo $livestream->is_free==0?"selected":""; ?>>YES</option>
                                        <option value="1" <?php echo $livestream->is_free==1?"selected":""; ?>>NO</option>
                                    </select>
                                </div>
                            </div>

                            <?php
                            $this->load->helper('form');
                            $error = $this->session->flashdata('error');
                            if($error)
                            {
                                ?>
                                <div class="alert alert-danger alert-dismissable">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                    <?php echo $error; ?>
                                </div>
                            <?php }
                            $success = $this->session->flashdata('success');
                            if($success)
                            {
                                ?>
                                <div class="alert alert-success alert-dismissable">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                    <?php echo $success; ?>
                                </div>
                            <?php } ?>


                            <div class="box-footer text-center" style="margin-top:20px;">
                               <button  class="btn btn-primary waves-effect" type="submit">UPDATE</button>

                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>

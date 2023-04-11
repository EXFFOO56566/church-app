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
                          <form method="POST" action="<?php echo base_url(); ?>savenewlivestream">

                            <div class="addon-line" style="margin-top:0px;">

                                <div class="form-line">
                                  <label>LiveStream Source</label>
                                    <select class="form-control" name="type" required="" autofocus="">
                                        <option value="m3u8">m3u8 Live</option>
                                        <option value="youtube">Youtube LiveVideo ID</option>
                                        <option value="rtmp">rtmp Live</option>
                                    </select>
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>LiveTv Title</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="title" placeholder="LiveTv Title" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>LiveTv CoverPhoto</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="cover_photo" placeholder="LiveTv CoverPhoto" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                   <label>LiveTv Link</label>

                                <div class="form-line">
                                    <input type="text" class="form-control" name="source" placeholder="LiveTv Link" autofocus="">
                                </div>

                            </div>


                            <div class="addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                  <label>Allow users watch this livetv for free?(if not free, only subscribed users can watch)</label>
                                    <select class="form-control" name="is_free" required="" autofocus="">
                                        <option value="0">YES</option>
                                        <option value="1">NO</option>
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
                               <button  class="btn btn-primary waves-effect" type="submit">SAVE</button>

                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>

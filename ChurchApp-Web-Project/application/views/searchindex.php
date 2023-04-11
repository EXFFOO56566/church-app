<section class="content">
    <div class="container-fluid">
        <div class="block-header">
            <h2>Create ElasticSearch Index</h2>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">
                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>createElasticIndex">
                             <h2><?php echo $status; ?></h2>

                            <div class="box-footer text-center">
                               <button class="btn btn-primary waves-effect" type="submit">CREATE ELASTICSEARCH INDEX</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
            </div>
    </div>
</section>

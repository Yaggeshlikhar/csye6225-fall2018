<?php
namespace Home\Controller;
use Common\Controller\CommonController;
use Think\Controller;
class IndexController extends CommonController {

    public function index(){
        $st = ststad();
        $st->increment("home");  
         $st->flush();
    $this->ajaxReturn(json_style(1,'has login',20000,array('currentTime'=>date('y-m-d h:i:s',time()))));

    }


}

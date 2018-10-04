<?php
namespace Home\Controller;
use Think\Controller;
class IndexController extends Controller {

    public function index(){
    $token = I('get.tokenID', null);
    if (isset($token)){
     if ($token != I('session.tokenID',null)){
         $this->ajaxReturn(json_style(1,"please relogin",10010));
     }else{

      $this->ajaxReturn(json_style(1,'has login',20000,array('currentTime'=>date('y-m-d h:i:s',time()))));
     }

    }else{
        $this->ajaxReturn(json_style(1,"sorry you must login first",10010));
    }
    }


}
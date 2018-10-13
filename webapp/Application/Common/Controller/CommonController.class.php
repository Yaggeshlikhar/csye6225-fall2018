<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/03/2018
 * Time: 16:34
 */
namespace Common\Controller;
use Think\Controller;
class CommonController extends Controller {

    //jude if login
    public function _initialize()
    {
       // $token = I('get.tokenID', 'd');
        $token=  I('session.tokenID',null);
        if (isset($token)){

            //if ($token != I('session.tokenID',null)){
             // $this->ajaxReturn(json_style(401,"error tokenID",10008));
           // }
        }else{
            $this->ajaxReturn(json_style(401,"sorry you must login first",10009));
        }
    }


}
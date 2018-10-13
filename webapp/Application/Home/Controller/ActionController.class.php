<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/03/2018
 * Time: 16:27
 */
namespace Home\Controller;
//use Common\Controller\CommonController;
use Home\InterfaceController\FortranscationController;

class ActionController extends FortranscationController{



    //create transcation API
    public function  createTransaction(){
        $this->ifRightsubmit(2);

        $postData = file_get_contents("php://input");
        $resultData = json_decode($postData,true);

      if (!isset($resultData['description'])||!isset($resultData['merchant'])||!isset($resultData['amount'])||!isset($resultData['category'])){
          $this->ajaxReturn(json_style(400,"bad request, lack paramters",10001));
      }

      $resultData['id'] = I("session.tokenID")."-".date("YmdHi");

      $resultData['date'] =date("Y-m-d H:i:s");
      $resultData['userid'] =I("session.userid");

      $tb_transcation = M('transcation');
      $res = $tb_transcation->add($resultData);
      if (!$res){
          $this->ajaxReturn(json_style(500,"database error",10008));
      } else{
          unset($resultData['userid']);
          $this->ajaxReturn(json_style(201,"success created",10010,$resultData));
      }
    }


    //retrive tanscation
    public  function  retrieveTransaction(){

    $this->ifRightsubmit(1);
     $where['userid'] =I('session.userid');
     $tb_transcation = M('transaction');
     $res = $tb_transcation->field("id,description,merchant,amount,date,category")->where($where)->select();
     $this->ajaxReturn(json_style(200,"ok",10011,$res));
    }


    //update transcation
    public  function  updateTransaction(){
        $this->ifRightsubmit(3);
        $putData = file_get_contents("php://input");
        $resultData = json_decode($putData,true);

     if (!isset($resultData['id'])){
      $this->ajaxReturn(json_style(400,"bad request, lack paramters",10001));
     }

      $this->ifAuth($resultData['id']);
      $tb_transcation = M('transaction');
      $res = $tb_transcation->save($resultData);

     if ($res ===false){
        $this->ajaxReturn(json_style(500,"database error",10008));
     }else{
        $res = $tb_transcation->where(array('id'=>$resultData['id']))->find();
        $this->ajaxReturn(json_style(201,"update success",10012,$res));
     }
    }


    //delete transcation
    public  function  deleteTransaction(){
        $this->ifRightsubmit(4);
        $deleteData = file_get_contents("php://input");
        $resultData = json_decode($deleteData,true);
        if (!isset($resultData['id'])) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $this->ifAuth($resultData['id']);
        $tb_transcation = M('transaction');
     $res = $tb_transcation->where(array("id"=>$resultData['id']))->find();
     if (!isset($res)) {
      $this->ajaxReturn(json_style(204,"no this transaction",10013));
     }
     if ($res['userid'] !=I('session.userid')) {
      $this->ajaxReturn(json_style(401,"no permission",10016));
     }

        $res =$tb_transcation->where($resultData)->delete();
    
        if ($res===false){
            $this->ajaxReturn(json_style(500,"database error",10008));
        }else{
            $this->ajaxReturn(json_style(200,"delete success",10014));
        }
    }



}




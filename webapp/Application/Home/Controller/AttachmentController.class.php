<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/13/2018
 * Time: 12:15
 */

namespace Home\Controller;

use Home\InterfaceController\FortranscationController;
use Home\InterfaceController\PutController;

class AttachmentController extends FortranscationController
{

    //Attach a file to the transaction
    public function attachFile()
    {

        $this->ifRightsubmit(2);
        $transactionid = I('get.transactionid', null);
        if (!isset($transactionid)) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);
        $info = $this->Uploadpicture();

        $filename = 'Uploads' . $info['savepath'] . $info['savename'];
        //save in data
        $s3ulr = uploadTos3($filename);

        $data['s3url'] = $s3ulr;
        $data['transactionid'] = $transactionid;
        $data['localurl'] = $filename;
        $tb_receipt = M('receipt');
        $res = $tb_receipt->add($data);
        if ($res) {
            $res = $tb_receipt->where(array("attachmentid" => $res))->find();
            $this->ajaxReturn(json_style(201, "success created", 10010, $res));
        } else {
            $this->ajaxReturn(json_style(500, "database error", 10008));
        }

    }

    //Get list of files attached to the transaction
    public function listAttachement()
    {
        $this->ifRightsubmit(1);
        $transactionid = I('get.transactionid', null);
        if (!isset($transactionid)) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);
        $tb_receipt = M('receipt');
        $where['transactionid'] = $transactionid;
        $res = $tb_receipt->where($where)->select();
        $this->ajaxReturn(json_style(200, "ok", 10011, $res));
    }

    //Update file attached to the transactio
    public function updateAttachment()
    {
        $this->ifRightsubmit(2);
        $transactionid = I('get.transactionid', null);
        $attachmentid = I('post.attachmentid', null);

        if (!isset($transactionid) || !isset($attachmentid)) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);

        $this->ifAttachment($attachmentid);

        $info = $this->Uploadpicture();
        $filename = 'Uploads' . $info['savepath'] . $info['savename'];
        $s3ulr = uploadTos3($filename);
        $data['s3url'] = $s3ulr;
        $data['localurl'] = $filename;
        $data['attachmentid'] = $attachmentid;
        $tb_receipt = M('receipt');
        $res = $tb_receipt->save($data);
        if ($res) {
            $res = $tb_receipt->where(array("attachmentid" => $res))->find();
            $this->ajaxReturn(json_style(201, "success Update", 10010, $res));
        } else {
            $this->ajaxReturn(json_style(500, "database error", 10008));
        }

    }


    //Delete
    public  function  deleteAttachment(){
        $this->ifRightsubmit(4);
        $putData = file_get_contents("php://input");
        $resultData = json_decode($putData,true);
        $transactionid = I('get.transactionid', null);
        if (!isset($transactionid) || !$resultData['attachmentid']) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);
        $this->ifAttachment($resultData['attachmentid']);
        if (isset($res)){
        $this->ajaxReturn(json_style(500, "database error", 10008));
        }
    }





}
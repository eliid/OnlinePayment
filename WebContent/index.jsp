<!--   
*******************************************************************************  
网上支付，两种接入方案：1)直接与银行对接。2)通过中间公司间接与银行对接  
1)直接与银行对接  
   优点：由于是直接与银行进行财务结算，故交易资金比较安全  
         适合资金流量比较大的(比如每月结算金额达到佰万以上)的企业  
   缺点：开发工作量比较大。银行会不定期升级交易系统，故企业也需要作相应改动  
         而且企业每年还需要向银行交纳一定数量的接口应用费  
2)通过中间公司间接与银行对接  
   优点：开发工作量较少。由于使用的是中间企业提供的接入规范，故银行升级系统时不需要企业作相应修改  
         除非中间企业的接入规范发生了改变，企业才作相应修改  
         由于只是与一家中间企业对接，故其接入费用也比较低  
         适合资金流量比较小的(比如每月结算金额在几十万以下的中小企业)  
   缺点：由于是与中间企业进行资金结算，而目前所有中间企业都是私企，故资金安全是个大问题  
********************************************************************************  
目前国内做的比较好的中间支付公司  
首信易支付：http://www.beijing.com.cn  
           每年交纳一定的接口使用费，并从交易金额中扣除1%的手续费。红孩子、当当网、京东商城等用之  
易宝支付：http://www.yeepay.com  
         接入免费，只从交易金额中扣除1%的手续费。盛大、艺龙网、巴巴运动网等用之  
********************************************************************************  
支付流程，大致如下：(可参考//WebRoot//WEB-INF//page//connection.jsp来理解)  
通过HTTP的方式向易宝支付网关发起支付请求，即向connection.jsp中注释部分的测试或正式网关发起请求  
该请求可以是GET或者POST方式，页面应采用GBK或者GB2312编码  
易宝支付网关对企业发来的数据，使用用户的密钥生成HMAC-MD5  
然后与企业发来的HMAC-MD5(即表单中hmac字段提供的值)比较  
若二者相同，则将请求转发到银行网关  
当用户支付完成后，银行网关会引导用户的浏览器重定向到易宝支付网关  
接着易宝支付网关再引导浏览器重定向到企业提供的url页面(即表单中p8_Url提供的值)  
********************************************************************************  
 -->
<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>Java在线支付_第一步_选择银行</title>
</head>
<body>
	<form action="PaymentSendServlet" method="POST">  
	    <table align="center" width="600" border="6" cellspacing="0" cellpadding="2">  
	        <tr>  
	            <td align="center" colspan="4" bgcolor="#FFD2E9">  
	                <b>订单号：</b><input type="text" name="orderID">      
	                <b>应付金额：￥</b><input type="text" name="amount" size="6"><b>元</b>  
	            </td>  
	        </tr>  
	        <tr>  
	            <td colspan="4"> </td>  
	        </tr>  
	        <tr>  
	            <td colspan="4" bgcolor="#C0C0C0">请选择在线支付银行</td>  
	        </tr>  
	        <tr>  
	            <td height="25" width="24%"><input type="radio" name="pd_FrpId" value="ICBC-NET">工商银行</td>  
	            <td height="25" width="24%"><input type="radio" name="pd_FrpId" value="CMBCHINA-NET">招商银行</td>  
	            <td height="25" width="24%"><input type="radio" name="pd_FrpId" value="ABC-NET">农业银行</td>  
	            <td height="25" width="28%"><input type="radio" name="pd_FrpId" value="CCB-NET">建设银行</td>  
	        </tr>  
	        <tr>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="CEB-NET" >光大银行</td>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="BOCO-NET">交通银行</td>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="CMBC-NET">民生银行</td>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="SDB-NET">深圳发展银行</td>  
	        </tr>  
	        <tr>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="BCCB-NET">北京银行</td>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="CIB-NET">兴业银行</td>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="ECITIC-NET">中信银行</td>  
	            <td height="25"><input type="radio" name="pd_FrpId" value="SPDB-NET">浦东发展银行</td>  
	        </tr>  
	        <tr>  
	            <td colspan="4"> </td>  
	        </tr>  
	        <tr>  
	            <td colspan="4" align="center" bgcolor="#FFDAB5"><input type="submit" value="  确认支付  "/></td>  
	        </tr>  
	    </table>  
	</form>  
</body>
</html>
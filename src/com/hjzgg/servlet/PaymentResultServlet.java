package com.hjzgg.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hjzgg.util.PaymentUtil;

/**
 * Servlet implementation class PaymentResultServlet
 */
@WebServlet("/PaymentResultServlet")
public class PaymentResultServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PaymentResultServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		process(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		process(request, response);
	}
	
	private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");  
        
        //测试商户：商家ID  
        String p1_MerId = "10000432521";  
        //测试商户：商家密钥  
        String keyValue = "8UPp0KE8sq73zVP370vko7C39403rtK1YwX40Td6irH216036H27Eb12792t";  
          
        String r0_Cmd = request.getParameter("r0_Cmd");      //业务类型  
        String r1_Code = request.getParameter("r1_Code");    //扣款结果。1:扣款成功  
        String r2_TrxId = request.getParameter("r2_TrxId");  //易宝交易订单号  
        String r3_Amt = request.getParameter("r3_Amt");      //扣款金额。交易结束后，易宝交易系统将实际扣款金额返回给商户  
        String r4_Cur = request.getParameter("r4_Cur");      //交易币种。人民币为CNY  
        String r5_Pid = request.getParameter("r5_Pid");      //商品ID  
        String r6_Order = request.getParameter("r6_Order");  //商户订单号  
        String r7_Uid = request.getParameter("r7_Uid");      //易宝会员ID  
        String r8_MP = request.getParameter("r8_MP");        //商户扩展信息。可任意填写1K的字符串，交易返回时将原样返回  
        String r9_BType = request.getParameter("r9_BType");  //交易结果通知类型。1:交易成功回调(浏览器重定向)，2:交易成功主动通知(服务器点对点通讯)  
        String hmac = request.getParameter("hmac");          //MD5交易签名  
          
        boolean result = PaymentUtil.verifyCallback(  
                hmac, p1_MerId, r0_Cmd, r1_Code, r2_TrxId, r3_Amt, r4_Cur,  
                r5_Pid, r6_Order, r7_Uid, r8_MP, r9_BType, keyValue);  
          
        if (result) {  
            if ("1".equals(r1_Code)) {  
                StringBuffer message = new StringBuffer();  
                message.append("订单号为：" + r6_Order + " 的订单支付成功，"); //此时数据库中订单支付状态应为已支付，否则容易出现"无限刷点卡"的BUG  
                message.append("用户支付了" + r3_Amt + "元。<br/>");  
                message.append("交易结果通知类型：");  
                if ("1".equals(r9_BType)) {  
                    message.append("浏览器重定向。<br/>");  
                } else if ("2".equals(r9_BType)) {  
                    message.append("易宝支付网关后台程序通知。<br/>");  
                }  
                message.append("易宝订单系统中的订单号为：" + r2_TrxId);  
                request.setAttribute("message", message);  
            } else {  
                request.setAttribute("message", "用户支付失败");  
            }  
        } else {  
            request.setAttribute("message", "数据来源不合法");  
        }  
        request.getRequestDispatcher("/WEB-INF/page/paymentResult.jsp").forward(request, response);  
	}
}

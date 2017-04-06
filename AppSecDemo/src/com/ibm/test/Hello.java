package com.ibm.test;

import java.io.IOException;
import java.io.PrintWriter;
//added test comment
import javax.servlet.Servlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Hello extends HttpServlet implements Servlet{

	public void doGet(HttpServletRequest req, HttpServletResponse resp){
		PrintWriter out;//add comment
		try {
			out = resp.getWriter();
			out.println("Hi There!");
			out.print("version: 003");
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}

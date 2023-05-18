<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	

	// 오라클 DB 연결
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	int totalRow = 0;
	String totalRowSql = "select count(*) from employees";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	if(totalRowRs.next()) {
		totalRow = totalRowRs.getInt(1);
	}
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1) * rowPerPage + 1;
	int endRow = beginRow + (rowPerPage-1);
	if(endRow > totalRow) {
		endRow = totalRow;
	}
	
	/*
	select 번호, 직원ID, 이름, 연봉, 급여순위 
		from 
		(select rownum 번호, 직원ID, 이름, 연봉, 급여순위 
			from 
			(select employee_id 직원ID, last_name 이름, salary 연봉, rank() over(order by salary desc) 급여순위 from employees))
	where 번호 between 1 and 10
	*/
	
	String rankSql = "select 번호, 직원ID, 이름, 연봉, 급여순위 from (select rownum 번호, 직원ID, 이름, 연봉, 급여순위 from (select rownum 번호, employee_id 직원ID, last_name 이름, salary 연봉, rank() over(order by salary desc) 급여순위 from employees)) where 번호 between ? and ?";
	PreparedStatement rankStmt = conn.prepareStatement(rankSql);
	rankStmt.setInt(1, beginRow);
	rankStmt.setInt(2, endRow);
	ResultSet rankRs = rankStmt.executeQuery();
	ArrayList<HashMap<String, Object>> rankList = new ArrayList<>();
	while(rankRs.next()) {
		HashMap<String, Object> r = new HashMap<String, Object>();
		r.put("번호", rankRs.getInt("번호"));
		r.put("직원ID", rankRs.getString("직원ID"));
		r.put("이름", rankRs.getString("이름"));
		r.put("연봉", rankRs.getInt("연봉"));
		r.put("급여순위", rankRs.getInt("급여순위"));
		rankList.add(r);
	}
	
	System.out.println(rankList.size() + " <-- rankList.size()");

%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>rankFunctionEmpList</title>
</head>
<body>
	<h1>rankFunctionEmpList</h1>
	<table border ="1">
		<tr>
			<td>번호</td>
			<td>직원ID</td>
			<td>이름</td>
			<td>연봉</td>
			<td>급여순위</td>
		</tr>
	<%
		for(HashMap<String, Object> r : rankList) {
	%>
		<tr>
			<td><%=(Integer)(r.get("번호"))%></td>
			<td><%=(String)(r.get("직원ID"))%></td>
			<td><%=(String)(r.get("이름"))%></td>
			<td><%=(Integer)(r.get("연봉"))%></td>
			<td><%=(Integer)(r.get("급여순위"))%></td>
		<tr>
	<%
		}
	%>   
	</table>
	
	<%
		/*
			currentPage						minPage ~ maxPage
			 1	 		(1-1) / 10	= 0			1	~	10
			 2	 		(2-1) / 10	= 0			1	~	10
			 10	 		(10-1)/ 10	= 0			1	~	10
			
			 11			(11-1) / 10	= 1			11	~	20
			 12			(12-1) / 10	= 1			11	~	20
			 20			(20-1) / 10	= 1			11	~	20
			
			(currentPage-1) / pagePerPage * pagePerPage + 1		--> minPage
			 minPage + (pagePerPage-1)							--> maxPage
			 maxPage < lastPage									--> maxPage = lastPage
		*/
	
		
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
		// 페이지 네비게이션 페이징
		int pagePerPage = 10;
		
		int minPage = ((currentPage-1) / pagePerPage * pagePerPage) + 1;
		int maxPage = minPage + (pagePerPage - 1);
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
		
		if(minPage > 1) {
	%>
		<a href="./rankFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>
	<%	
		}
		
		for(int i=minPage; i<=maxPage; i=i+1) {
			if(i == currentPage) {
	%>
			<span><%=i%></span>&nbsp;
	<%
			} else {
	%>
			<a href="./rankFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;
	<%	
			}
		}
		
		if(maxPage != lastPage) {
	%>
		<!-- maxPage + 1 -->
		<a href="./rankFunctionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
	<%
		}
	%>	
	
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	// 오라클 DB 연결
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	
	/* nvl */
	// nvl(값1, 값2) : 값1이 null이 아니면 값1을 반환, 값1이 null이면 값2를 반환한다
	PreparedStatement nvlStmt = null;
	ResultSet nvlRs = null;
	String nvlSql = "select 이름, nvl(일분기, 0) 일분기 from 실적";
	nvlStmt = conn.prepareStatement(nvlSql);
	nvlRs = nvlStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> nvlList = new ArrayList<HashMap<String, Object>>();
	
	while(nvlRs.next()) {
		HashMap<String, Object> n = new HashMap<String, Object>();
		n.put("이름", nvlRs.getString("이름")); 
		n.put("일분기", nvlRs.getString("일분기"));
		nvlList.add(n);
	}
	
	
	/* nvl2 */
	// nvl2(값1, 값2, 값3) : 값1이 null아니면 값2반환, 값1이 null이면 값3을 반환
	PreparedStatement nvl2Stmt = null;
	ResultSet nvl2Rs = null;
	String nvl2Sql = "select 이름, nvl2(일분기, 'success', 'fail') 일분기 from 실적";
	nvl2Stmt = conn.prepareStatement(nvl2Sql);
	nvl2Rs = nvl2Stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> nvl2List = new ArrayList<HashMap<String, Object>>();
	
	while(nvl2Rs.next()) {
		HashMap<String, Object> n2 = new HashMap<String, Object>();
		n2.put("이름", nvl2Rs.getString("이름"));
		n2.put("일분기", nvl2Rs.getString("일분기"));
		nvl2List.add(n2);
	}
	
	
	/* nullif */
	// nullif(값1, 값2) : 값1과 값2가 같으면 null을 반환 (null이 아닌값이 null로 치환에 사용)
	PreparedStatement nullifStmt = null;
	ResultSet nullifRs = null;
	String nullifSql = "select 이름, nullif(사분기, 100) 사분기 from 실적";
	nullifStmt = conn.prepareStatement(nullifSql);
	nullifRs = nullifStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> nvlifList = new ArrayList<HashMap<String, Object>>();
	
	while(nullifRs.next()) {
		HashMap<String, Object> ni = new HashMap<String, Object>();
		ni.put("이름", nullifRs.getString("이름"));
		ni.put("사분기", nullifRs.getString("사분기"));
		nvlifList.add(ni);
	}
	
	
	/* coalesce */
	// coalesce(값1, 값2, 값3, .....) : 입력값 중 null아닌 첫번째값을 반환
	PreparedStatement coalesceStmt = null;
	ResultSet coalesceRs = null;
	String coalesceSql = "select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) 첫실적 from 실적";
	coalesceStmt = conn.prepareStatement(coalesceSql);
	coalesceRs = coalesceStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> coalesceList = new ArrayList<HashMap<String, Object>>();
	
	while(coalesceRs.next()) {
		HashMap<String, Object> c = new HashMap<String, Object>();
		c.put("이름", coalesceRs.getString("이름"));
		c.put("첫실적", coalesceRs.getString("첫실적"));
		coalesceList.add(c);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- nvl(값1, 값2) : 값1이 null이 아니면 값1을 반환, 값1이 null이면 값2를 반환한다 -->
	<h1>nvl(일분기, 0)</h1>
	<p>일분기에 값이 있으면 일분기 값 출력, 없으면 0 출력</p>
	<table border="1">
		<tr>
			<th>이름</th>
			<th>일분기</th>
		</tr>
		<%
			for(HashMap<String, Object> n : nvlList) {
		%>
				<tr>
					<td><%=n.get("이름")%></td>
					<td><%=n.get("일분기")%></td>
				</tr>
		<%		
			}
		%>
	</table>
	
	<br>
	
	<!-- nvl2(값1, 값2, 값3) : 값1이 null아니면 값2반환, 값1이 null이면 값3을 반환 -->
	<h1>nvl2(일분기, 'success', 'fail')</h1>
	<p>일분기에 값이 있으면 success, 없으면 fail</p>
	<table border="1">
		<tr>
			<th>이름</th>
			<th>일분기</th>
		</tr>
		<%
			for(HashMap<String, Object> n2 : nvl2List) {
		%>
				<tr>
					<td><%=n2.get("이름")%></td>
					<td><%=n2.get("일분기")%></td>
				</tr>
		<%		
			}
		%>
	</table>
	
	<br>
	
	<!-- nullif(값1, 값2) : 값1과 값2가 같으면 null을 반환 (null이 아닌값이 null로 치환에 사용) -->
	<h1>nullif(사분기, 100)</h1>
	<p>사분기가 100 이면 null로 치환</p>
	<table border="1">
		<tr>
			<th>이름</th>
			<th>사분기</th>
		</tr>
		<%
			for(HashMap<String, Object> ni : nvlifList) {
		%>
				<tr>
					<td><%=ni.get("이름")%></td>
					<td><%=ni.get("사분기")%></td>
				</tr>
		<%		
			}
		%>
	</table>
	
	<br>
	
	<!-- coalesce(값1, 값2, 값3, .....) : 입력값 중 null아닌 첫번째값을 반환 -->
	<h1>coalesce(일분기, 이분기, 삼분기, 사분기)</h1>
	<p>일분기, 이분기, 삼분기, 사분기 중 첫 실적</p>
	<table border="1">
		<tr>
			<th>이름</th>
			<th>첫실적</th>
		</tr>
		<%
			for(HashMap<String, Object> c : coalesceList) {
		%>
				<tr>
					<td><%=c.get("이름")%></td>
					<td><%=c.get("첫실적")%></td>
				</tr>
		<%		
			}
		%>
	</table>
</body>
</html>
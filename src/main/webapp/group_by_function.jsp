<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<% 
	// 오라클 DB 연결
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	// 1. group by 절 기본 : 확장함수X 
	/*
		select department_id, job_id, count(*) from employees
		group by department_id, job_id;
	*/
	String groupBySql = "select department_id, job_id, count(*) from employees group by department_id, job_id";
	PreparedStatement groupByStmt = conn.prepareStatement(groupBySql);
	ResultSet groupByRs = groupByStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> groupByList = new ArrayList<>();

	while(groupByRs.next()) {
		HashMap<String, Object> g = new HashMap<String, Object>();
		g.put("department_id", groupByRs.getString("department_id")); 
		g.put("job_id", groupByRs.getString("job_id")); 
		g.put("count(*)", groupByRs.getInt("count(*)"));
		groupByList.add(g);
	}


	// 2. group by 절 확장함수 : rollup 	→ rollup()함수 매개값(컬럼명)이 2개 이상일때
	/*
		select department_id, job_id, count(*) from employees
		group by rollup(department_id, job_id);
	*/
	String rollUpSql = "select department_id, job_id, count(*) from employees group by rollup(department_id, job_id)";
	PreparedStatement rollUpStmt = conn.prepareStatement(rollUpSql);
	ResultSet rollUpRs = rollUpStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> rollUpList = new ArrayList<>();

	while(rollUpRs.next()) {
		HashMap<String, Object> r = new HashMap<String, Object>();
		r.put("department_id", rollUpRs.getString("department_id")); 
		r.put("job_id", rollUpRs.getString("job_id")); 
		r.put("count(*)", rollUpRs.getInt("count(*)"));
		rollUpList.add(r);
	}


	// 3. group by 절 확장함수 : cube 
	/*
		select department_id, job_id, count(*) from employees
		group by cube(department_id, job_id);
	*/
	String cubeSql = "select department_id, job_id, count(*) from employees group by cube(department_id, job_id)";
	PreparedStatement cubeStmt = conn.prepareStatement(cubeSql);
	ResultSet cubeRs = cubeStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> cubeList = new ArrayList<>();

	while(cubeRs.next()) {
		HashMap<String, Object> c = new HashMap<String, Object>();
		c.put("department_id", cubeRs.getString("department_id")); 
		c.put("job_id", cubeRs.getString("job_id")); 
		c.put("count(*)", cubeRs.getInt("count(*)"));
		cubeList.add(c);
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>group_by_function</title>
</head>
<body>
<div>
		<h1>GROUP BY TEST</h1>
		<table border="1">
			<tr>
				<td>department_id</td>
				<td>job_id</td>
				<td>count(*)</td>
			</tr>
		<%
			for(HashMap<String, Object> b : groupByList){
		%>
				<tr>
					<td><%=(String)b.get("department_id") %></td>
					<td><%=(String)b.get("job_id") %></td>
					<td><%=(Integer)b.get("count(*)") %></td>
				</tr>
		<%
			}
		%>
		</table>
	</div>
	
	<br>
	
	<!-- rollup은 group by 결과에 + 전체집계 + 첫번째 컬럼집계 -->
	<div>
		<h1>ROLLUP TEST</h1>
		<table border="1">
			<tr>
				<td>department_id</td>
				<td>job_id</td>
				<td>count(*)</td>
			</tr>
		<%
			for(HashMap<String, Object> r : rollUpList){
		%>
				<tr>
					<td><%=(String)r.get("department_id")%></td>
					<td><%=(String)r.get("job_id")%></td>
					<td><%=(Integer)r.get("count(*)") %></td>
				</tr>
		<%
			}
		%>
		</table>
	</div>
	
	<br>
	
	<!-- cube는 group by 결과에 + 전체집계 + 매개값으로 사용된 모든 컬럼집계 -->
	<div>
		<h1>CUBE TEST</h1>
		<table border="1">
			<tr>
				<td>department_id</td>
				<td>job_id</td>
				<td>count(*)</td>
			</tr>
		<%
			for(HashMap<String, Object> c : cubeList){
		%>
				<tr>
					<td><%=(String)c.get("department_id") %></td>
					<td><%=(String)c.get("job_id") %></td>
					<td><%=(Integer)c.get("count(*)") %></td>
				</tr>
		<%
			}
		%>
		</table>
	</div>
</body>
</html>

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
 
public class DBConnection 
{
    public static Connection dbConn;
    
        public static Connection getConnection()
        {
            Connection conn = null;
            try {
                String user = "scott"; 
                String pw = "tiger";
                String url = "jdbc:oracle:thin:@localhost:1521:XE";
                
                Class.forName("oracle.jdbc.driver.OracleDriver");        
                conn = DriverManager.getConnection(url, user, pw);
                
                System.out.println("Database에 연결되었습니다.\n");
                
            } catch (ClassNotFoundException e) {
                System.out.println("DB 드라이버 로딩 실패 :"+e.toString());
            } catch (SQLException e) {
                System.out.println("DB 접속실패 : "+e.toString());
            } catch (Exception e) {
                System.out.println("Unkonwn error");
                e.printStackTrace();
            }
            return conn;     
        }
}


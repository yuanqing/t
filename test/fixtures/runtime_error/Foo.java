import java.util.Scanner;

public class Foo {

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    String str = sc.nextLine();
    if (str.equals("2")) {
      throw new RuntimeException();
    } else {
      System.out.println(str);      
    }
    sc.close();
  }

}

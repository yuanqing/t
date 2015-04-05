import java.util.Scanner;

public class Reverse {

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    while (sc.hasNextLine()) {
      System.out.println(new StringBuilder(sc.nextLine()).reverse().toString());
    }
    sc.close();
  }

}

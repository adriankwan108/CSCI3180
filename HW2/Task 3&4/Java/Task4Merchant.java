import java.util.Scanner;

public class Merchant {
  private int elixirPrice;
  private int shieldPrice;
  private Pos pos;

  public Merchant() {
    // TODO: Initialization.
    this.elixirPrice = 1;
    this.shieldPrice = 2;
    this.pos = new Pos();
  }

  public void actionOnSoldier(Task4Soldier soldier) {
    this.talk("Do you want to buy something? (1. Elixir, 2. Shield, 3. Leave.) Input: ");

    // TODO: Main logic.
    boolean fightEnabled = true;
    while(fightEnabled)
    {
        this.talk("Do you want to buy something? (1. Elixir, 2.Shield, 3. Leave.) Input:%n ");
        Scanner sc = new Scanner(System.in);
        String choice = sc.nextLine();
        
        if(choice.equalsIgnoreCase("1"))
        {
            if(soldier.getCoins()>0){
                System.out.print("=>You buy an elixir.%n");
                soldier.addElixir();
                soldier.useCoins(1);
                fightEnabled = false;
            }else{
                this.talk("You don't have enough coins.%n");
                fightEnabled = false;
            }
        }else if(choice.equalsIgnoreCase("2"))
        {
            if(soldier.getCoins()>1){
                System.out.print("=>You buy a shield.%n");
                soldier.useCoins(2);
                soldier.addDefence();
                fightEnabled = false;
            }else{
                this.talk("You don't have enough coins.%n");
                fightEnabled = false;
            }
        }else if(choice.equalsIgnoreCase("3"))
        {
            System.out.print("=>You leave.%n");
            fightEnabled = false;
        }else{
            System.out.print("=>Illegal choice!%n");
        }
    }
    // If the soldier doesn't have enough coins to buy what (s)he wants, the merchant will say "You don't have enough coins.%n%n".
    // Then, the soldier will automatically leave.

    // After the soldier successfully buys an item from the merchant, (s)he will also automatically leave.
  }

  public void talk(String text) {
    System.out.printf("Merchant$: " + text);
  }

  // TODO: Other functions.
  public Pos getPos(){
      return this.pos;
  }
  
  public void setPos(int row, int column){
      this.pos.setPos(row, column);
  }
  
  public void displaySymbol(){
      System.out.print("$");
  }
       
}
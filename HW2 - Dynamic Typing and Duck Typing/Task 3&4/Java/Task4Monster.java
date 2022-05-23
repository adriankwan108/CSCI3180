import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;

/**
 *
 * @author Kwan
 */
public class Task4Monster extends Monster{
    
    public Task4Monster(int monsterID, int healthCapacity){
        super(monsterID,healthCapacity);
    }
    
    public void dropItems(Task4Soldier soldier){
        super.dropItems(soldier);
        soldier.addCoins();
    }
    
    public void actionOnSoldier(Task4Soldier soldier) {
        if (this.health <= 0) {
            this.talk("You had defeated me.%n%n");
        } else {
            if (this.requireKey(soldier.getKeys())) {
                this.fight(soldier);
            } else {
                this.displayHints();
             }
        }
    }
    
    public void fight(Task4Soldier soldier){
        super.fight(soldier);
        if(this.health<=0){
            this.dropItems(soldier);
        }
    }
    
}

abstract class Entity {
  private int life;
  private Equipment equipment;

  public Entity(int life, Equipment Equipment){
    this.life = life;
    this.equipment = equipment;
  }

  public int getLife() { return this.life; }
  public void setLife(int life) { this.life = life; }

  abstract void attack(Enemy e);
  abstract void escape();
  // ...
}

interface Attackable {
  public int getPower();

  default void attack(Enemy e){
    e.setLife(e.getLife() - getPower());
  }
}

public class Hero {
  public void attack(Enemy e){
    // Filter equipment by things that I can attack with
    Attackable attackable = this.equipment.attackable();

    // attack
    attackable.attack(e);
  }
}

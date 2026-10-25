INSERT INTO categories (name, code) VALUES
  ('Процессоры', 'cpu'),
  ('Материнские платы', 'motherboard'),
  ('Оперативная память', 'ram'),
  ('Блоки питания', 'psu'),
  ('Накопители', 'storage');

INSERT INTO manufacturers (name) VALUES
  ('Демонстрационный производитель A'),
  ('Демонстрационный производитель B');

INSERT INTO components
  (category_id, manufacturer_id, name, base_price, characteristics, power_watts)
VALUES
  ((SELECT id FROM categories WHERE code='cpu'),
   (SELECT id FROM manufacturers WHERE name='Демонстрационный производитель A'),
   'CPU Demo AM5', 25000, '{"socket":"AM5","memory_type":"DDR5"}', 120),
  ((SELECT id FROM categories WHERE code='motherboard'),
   (SELECT id FROM manufacturers WHERE name='Демонстрационный производитель B'),
   'Board Demo AM5', 18000, '{"socket":"AM5","memory_type":"DDR5","memory_max_gb":128,"memory_slots":4}', 60),
  ((SELECT id FROM categories WHERE code='ram'),
   (SELECT id FROM manufacturers WHERE name='Демонстрационный производитель A'),
   'RAM Demo DDR5 16GB', 5000, '{"memory_type":"DDR5","capacity_gb":16,"module_count":1}', 5),
  ((SELECT id FROM categories WHERE code='psu'),
   (SELECT id FROM manufacturers WHERE name='Демонстрационный производитель B'),
   'PSU Demo 650W', 9000, '{"power_watts":650}', 0),
  ((SELECT id FROM categories WHERE code='storage'),
   (SELECT id FROM manufacturers WHERE name='Демонстрационный производитель A'),
   'SSD Demo M.2', 7000, '{"interface":"M.2","capacity_gb":1000}', 5);


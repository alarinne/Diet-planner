-- USERS
create table if not exists users (
                                     id bigserial primary key,
                                     email varchar(255) not null,
                                     password_hash varchar(255) not null,
                                     role varchar(32) not null default 'USER',
                                     created_at timestamptz not null default now(),
                                     updated_at timestamptz not null default now()
);
create unique index if not exists ux_users_email_ci on users (lower(email));

create table if not exists user_profile (
                                            user_id bigint primary key references users(id) on delete cascade,
                                            full_name varchar(255),
                                            gender varchar(10) check (gender in ('MALE','FEMALE','OTHER')),
                                            birth_date date,
                                            height_cm numeric(5,2),
                                            current_weight_kg numeric(5,2)
);

create table if not exists user_goals (
                                          user_id bigint primary key references users(id) on delete cascade,
                                          target_weight_kg numeric(5,2),
                                          target_calories int,
                                          protein_pct numeric(5,2),
                                          fat_pct numeric(5,2),
                                          carbs_pct numeric(5,2),
                                          diet_type varchar(50),
                                          allergies_json jsonb,
                                          updated_at timestamptz not null default now()
);

-- FOODS
create table if not exists foods (
                                     id bigserial primary key,
                                     name varchar(255) not null,
                                     brand varchar(255),
                                     source varchar(50) not null default 'local',  -- 'local' | 'openfoodfacts' | 'edamam'
                                     source_id varchar(255),
                                     kcal int not null,
                                     protein_g numeric(6,2) not null,
                                     fat_g numeric(6,2) not null,
                                     carbs_g numeric(6,2) not null,
                                     nutrients_json jsonb,
                                     tags jsonb,
                                     created_at timestamptz not null default now(),
                                     updated_at timestamptz not null default now()
);
create unique index if not exists ux_foods_source_source_id
    on foods (source, source_id) where source_id is not null;
create unique index if not exists ux_foods_local_name_brand
    on foods (lower(name), coalesce(lower(brand), '')) where source = 'local';

-- RECIPES
create table if not exists recipes (
                                       id bigserial primary key,
                                       name varchar(255) not null,
                                       author_user_id bigint references users(id) on delete set null,
                                       instructions text,
                                       tags jsonb,
                                       created_at timestamptz not null default now(),
                                       updated_at timestamptz not null default now()
);
create unique index if not exists ux_recipes_author_name
    on recipes (author_user_id, lower(name)) where author_user_id is not null;

create table if not exists recipe_ingredients (
                                                  recipe_id bigint not null references recipes(id) on delete cascade,
                                                  food_id bigint not null references foods(id),
                                                  grams numeric(8,2) not null check (grams > 0),
                                                  primary key (recipe_id, food_id)
);

-- MEAL PLANS
create table if not exists meal_plans (
                                          id bigserial primary key,
                                          user_id bigint not null references users(id) on delete cascade,
                                          day date not null,
                                          note varchar(500),
                                          created_at timestamptz not null default now(),
                                          unique (user_id, day)
);

create table if not exists meal_items (
                                          id bigserial primary key,
                                          meal_plan_id bigint not null references meal_plans(id) on delete cascade,
                                          meal_type varchar(20) not null check (meal_type in ('BREAKFAST','LUNCH','DINNER','SNACK')),
                                          food_id bigint references foods(id),
                                          recipe_id bigint references recipes(id),
                                          grams numeric(8,2) check (grams is null or grams > 0),
                                          servings numeric(8,2) check (servings is null or servings > 0),
                                          constraint chk_food_or_recipe check (
                                              (food_id is not null and recipe_id is null) or (food_id is null and recipe_id is not null)
                                              )
);
create unique index if not exists ux_meal_items_unique_row
    on meal_items (meal_plan_id, meal_type, coalesce(food_id, 0::bigint), coalesce(recipe_id, 0::bigint));

-- TRACKING
create table if not exists food_intakes (
                                            id bigserial primary key,
                                            user_id bigint not null references users(id) on delete cascade,
                                            taken_at timestamptz not null,
                                            meal_type varchar(20),
                                            food_id bigint references foods(id),
                                            recipe_id bigint references recipes(id),
                                            grams numeric(8,2),
                                            servings numeric(8,2),
                                            note varchar(500),
                                            constraint chk_intake_food_or_recipe_2 check (
                                                (food_id is not null and recipe_id is null) or (food_id is null and recipe_id is not null)
                                                )
);
create unique index if not exists ux_food_intakes_dedup
    on food_intakes (user_id, taken_at, coalesce(food_id, 0::bigint), coalesce(recipe_id, 0::bigint));

create table if not exists weight_log (
                                          id bigserial primary key,
                                          user_id bigint not null references users(id) on delete cascade,
                                          weighed_at date not null,
                                          weight_kg numeric(5,2) not null,
                                          unique (user_id, weighed_at)
);

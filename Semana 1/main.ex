defmodule InventoryManager do

  #Las funciones comentadas las realicé para probar de manera más directa las funciones que impacten el carrito de compras

  defstruct products: [], shoppingCar: []

  def add_product(inventory, name, price, stock) do
    products = inventory.products
    id = length(products) + 1
    product = %{id: id, name: name, price: price, stock: stock}
    IO.puts("Producto #{name} con stock #{stock} agregado con éxito. \n")
    %InventoryManager{products: products ++ [product]}
  end

  # def add_product_car(inventory, name, price, stock) do
  #   products = inventory.shoppingCar
  #   id = length(products) + 1
  #   product = %{id: id, name: name, price: price, stock: stock}
  #   IO.puts("Producto #{name} con stock #{stock} agregado con éxito. \n")
  #   %InventoryManager{shoppingCar: products ++ [product]}
  # end

  def list_products(inventory) do
    Enum.each(inventory.products, fn product ->
      IO.puts("#{product.id} #{product.name} -> Cantidad: #{product.stock} - Precio: #{product.price} \n")
    end)
  end

  # def list_car(inventory) do
  #   Enum.each(inventory.shoppingCar, fn product ->
  #     IO.puts("#{product.id} #{product.name} -> Cantidad: #{product.stock} - Precio: #{product.price} \n")
  #   end)
  # end

  def increase_stock(inventory, id, quantity) do
    updated_products = Enum.map(inventory.products, fn product ->
      if product.id == id do
        #%{product | stock: product.stock + quantity}
        Map.put(product, :stock, product.stock + quantity)
      else
        product
      end
    end)

    IO.puts("Stock del producto con ID #{id} incrementado en #{quantity} unidades.\n")
    %InventoryManager{inventory | products: updated_products}
  end

  def sell_product(inventory, id, quantity) do
    {updated_products, updated_cart} = Enum.reduce(inventory.products, {[], inventory.shoppingCar}, fn product, {acc_updated_products, acc_updated_cart} ->
      if product.id == id do
        update_product = Map.put(product, :stock, product.stock - quantity)
        {acc_updated_products ++ [update_product], acc_updated_cart ++ [update_product]}
      else
        {acc_updated_products ++ [product], acc_updated_cart}
      end
    end)

    IO.puts("Producto con ID #{id} se agregó #{quantity} unidades al carrito.\n")
    %InventoryManager{inventory | products: updated_products, shoppingCar: updated_cart}
  end

  def view_cart(cart) do
    total_price = Enum.reduce(cart, 0, fn element, acc_total ->
      IO.puts("#{element.id} #{element.name} -> Cantidad: #{element.stock} - Precio: #{element.price} \n")
      acc_total + (element.stock * element.price)
    end)

    IO.puts("Precio Total del carrito: #{total_price} \n")
  end

  def checkout(inventory, cart) do
    total_price = Enum.reduce(cart, 0, fn element, acc_total ->
      acc_total = acc_total + (element.stock * element.price)
    end)

    IO.puts("Cobro Total: #{total_price} \n")
    %InventoryManager{inventory | shoppingCar: []}
  end

  def run do
    invent_manager = %InventoryManager{}
    loop(invent_manager)
  end

  defp loop(inventory_manager) do
    IO.puts("""
    Gestor de Inventario
    1. Agregar Producto
    2. Listar Productos
    3. Incrementar Stock de un Producto
    4. Vender Producto
    5. Ver carrito de compras
    6. Pagar carrito de compras
    7. Salir
    """)

    IO.write("Seleccione una opción: ")
    option = String.trim(IO.gets(""))
    option = String.to_integer(option)

    case option do
      1 ->
        IO.write("Ingrese el nombre del producto: ")
        name = String.trim(IO.gets(""))

        IO.write("Ingrese el precio del producto: ")
        price = String.trim(IO.gets(""))
        price = String.to_integer(price)

        IO.write("Ingrese el stock del producto: ")
        stock = String.trim(IO.gets(""))
        stock = String.to_integer(stock)

        inventory_manager = add_product(inventory_manager, name, price, stock)
        loop(inventory_manager)

      2 ->
         list_products(inventory_manager)
         loop(inventory_manager)

      3 ->
        IO.write("Ingrese el ID del producto: ")
        id = String.trim(IO.gets(""))
        id = String.to_integer(id)

        IO.write("Ingrese la cantidad a incrementar: ")
        increment = String.trim(IO.gets(""))
        increment = String.to_integer(increment)

        inventory_manager = increase_stock(inventory_manager, id, increment)
        loop(inventory_manager)

      4 ->
        IO.write("Ingrese el ID del producto: ")
        id = String.trim(IO.gets(""))
        id = String.to_integer(id)

        IO.write("Ingrese la cantidad que desea vender: ")
        quantity = String.trim(IO.gets(""))
        quantity = String.to_integer(quantity)

        inventory_manager = sell_product(inventory_manager, id, quantity)
        loop(inventory_manager)

      5 ->
        view_cart(inventory_manager.shoppingCar)
        loop(inventory_manager)

      # 6 ->
      #   list_car(inventory_manager)
      #   loop(inventory_manager)

      # 7 ->
      #   IO.write("Ingrese el nombre del producto: ")
      #   name = String.trim(IO.gets(""))

      #   IO.write("Ingrese el precio del producto: ")
      #   price = String.trim(IO.gets(""))
      #   price = String.to_integer(price)

      #   IO.write("Ingrese el stock del producto: ")
      #   stock = String.trim(IO.gets(""))
      #   stock = String.to_integer(stock)

      #   inventory_manager = add_product_car(inventory_manager, name, price, stock)
      #   loop(inventory_manager)

      6 ->
        inventory_manager = checkout(inventory_manager, inventory_manager.shoppingCar)
        loop(inventory_manager)

      7 ->
        IO.puts("¡Adiós!")

      _ ->
        IO.puts("Opción no válida.")
        loop(inventory_manager)
    end

  end
end

InventoryManager.run()
